# دليل تنفيذ اللعب الجماعي المزامن على Cloudflare

## نظرة عامة

هذا الدليل يشرح كيفية تحويل لعبة Mystery Link من اللعب المحلي (Pass & Play) إلى اللعب الجماعي المزامن عبر الإنترنت باستخدام **Cloudflare Workers** و **Durable Objects**.

---

## إمكانيات Cloudflare للواقع الزمني (2025)

### ✅ ما يدعمه Cloudflare:

1. **Cloudflare Workers**: 
   - تشغيل كود JavaScript/TypeScript على حافة الشبكة
   - استجابة فورية (< 50ms في معظم المناطق)
   - دعم WebSockets

2. **Durable Objects**:
   - حالة مزامنة موزعة
   - مثيل واحد لكل غرفة لعبة
   - دعم WebSocket connections متعددة
   - تخزين حالة اللعبة في الذاكرة

3. **WebSockets**:
   - اتصال ثنائي الاتجاه
   - مزامنة فورية بين اللاعبين
   - دعم حتى 1000+ اتصال متزامن لكل Durable Object

### ⚠️ القيود:

- **Latency**: يعتمد على موقع اللاعبين (أفضل أداء في المناطق القريبة من Cloudflare edge)
- **State Persistence**: Durable Objects تحتفظ بالحالة في الذاكرة (قد تحتاج قاعدة بيانات للبيانات الدائمة)
- **Scaling**: كل غرفة لعبة = Durable Object واحد (ممتاز للعبة turn-based)

---

## البنية المقترحة

```
┌─────────────────┐
│  Flutter App    │
│  (Client)       │
└────────┬────────┘
         │ WebSocket
         │
┌────────▼────────────────────────┐
│  Cloudflare Worker               │
│  (Entry Point)                   │
│  - Route requests                │
│  - Handle WebSocket upgrades     │
└────────┬────────────────────────┘
         │
┌────────▼────────────────────────┐
│  Durable Object                 │
│  (Game Room)                    │
│  - Manage game state            │
│  - Handle player connections     │
│  - Broadcast events              │
└─────────────────────────────────┘
```

---

## الخطوة 1: إعداد Cloudflare Worker

### 1.1 إنشاء المشروع

```bash
# تثبيت Wrangler CLI
npm install -g wrangler

# إنشاء مشروع جديد
wrangler init mystery-link-backend
cd mystery-link-backend
```

### 1.2 ملف `wrangler.toml`

```toml
name = "mystery-link-backend"
main = "src/index.ts"
compatibility_date = "2024-12-01"

[durable_objects]
bindings = [
  { name = "GAME_ROOM", class_name = "GameRoom" }
]

[[migrations]]
tag = "v1"
new_classes = ["GameRoom"]
```

### 1.3 ملف `src/index.ts` (Entry Point)

```typescript
export interface Env {
  GAME_ROOM: DurableObjectNamespace<GameRoom>;
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);
    
    // WebSocket upgrade للعبة
    if (url.pathname.startsWith('/game/')) {
      const roomId = url.pathname.split('/')[2];
      const id = env.GAME_ROOM.idFromName(roomId);
      const stub = env.GAME_ROOM.get(id);
      return stub.fetch(request);
    }
    
    // REST API endpoints
    if (url.pathname === '/api/create-room') {
      return handleCreateRoom(env);
    }
    
    return new Response('Not Found', { status: 404 });
  },
};

async function handleCreateRoom(env: Env): Promise<Response> {
  const roomId = generateRoomId();
  const id = env.GAME_ROOM.idFromName(roomId);
  
  return new Response(JSON.stringify({ roomId }), {
    headers: { 'Content-Type': 'application/json' },
  });
}

function generateRoomId(): string {
  return Math.random().toString(36).substring(2, 6).toUpperCase();
}
```

---

## الخطوة 2: تنفيذ Durable Object (Game Room)

### 2.1 ملف `src/GameRoom.ts`

```typescript
export class GameRoom implements DurableObject {
  private state: DurableObjectState;
  private env: Env;
  private sessions: Map<string, WebSocket> = new Map();
  private gameState: GameState | null = null;
  private players: Map<string, PlayerInfo> = new Map();

  constructor(state: DurableObjectState, env: Env) {
    this.state = state;
    this.env = env;
  }

  async fetch(request: Request): Promise<Response> {
    // Upgrade to WebSocket
    const upgradeHeader = request.headers.get('Upgrade');
    if (upgradeHeader !== 'websocket') {
      return new Response('Expected WebSocket', { status: 426 });
    }

    const pair = new WebSocketPair();
    const [client, server] = Object.values(pair);

    await this.handleSession(server, request);

    return new Response(null, {
      status: 101,
      webSocket: client,
    });
  }

  async handleSession(ws: WebSocket, request: Request): Promise<void> {
    ws.accept();

    const url = new URL(request.url);
    const playerId = url.searchParams.get('playerId') || generateId();
    const playerName = url.searchParams.get('playerName') || 'Player';

    // إضافة اللاعب
    this.sessions.set(playerId, ws);
    this.players.set(playerId, {
      id: playerId,
      name: playerName,
      isHost: this.players.size === 0,
      score: 0,
    });

    // إرسال حالة اللعبة الحالية
    this.sendToPlayer(playerId, {
      type: 'gameState',
      state: this.gameState,
      players: Array.from(this.players.values()),
    });

    // إشعار اللاعبين الآخرين
    this.broadcast({
      type: 'playerJoined',
      player: this.players.get(playerId),
    }, playerId);

    // معالجة الرسائل الواردة
    ws.addEventListener('message', async (event) => {
      try {
        const message = JSON.parse(event.data as string);
        await this.handleMessage(playerId, message);
      } catch (e) {
        console.error('Error handling message:', e);
      }
    });

    // تنظيف عند انقطاع الاتصال
    ws.addEventListener('close', () => {
      this.sessions.delete(playerId);
      this.players.delete(playerId);
      this.broadcast({
        type: 'playerLeft',
        playerId,
      });
    });
  }

  async handleMessage(playerId: string, message: any): Promise<void> {
    switch (message.type) {
      case 'startGame':
        await this.startGame(message.config);
        break;
      
      case 'selectOption':
        await this.handleOptionSelection(playerId, message);
        break;
      
      case 'timerTick':
        this.broadcast({
          type: 'timerTick',
          remainingSeconds: message.remainingSeconds,
        });
        break;
      
      default:
        console.warn('Unknown message type:', message.type);
    }
  }

  async startGame(config: GameConfig): Promise<void> {
    // تحميل اللغز (يمكن جلبها من KV أو قاعدة بيانات)
    const puzzle = await this.loadPuzzle(config);
    
    this.gameState = {
      puzzle,
      currentStep: 1,
      chosenNodes: [],
      score: 0,
      remainingSeconds: puzzle.timeLimit,
      startTime: Date.now(),
      currentPlayerIndex: 0,
    };

    this.broadcast({
      type: 'gameStarted',
      gameState: this.gameState,
    });
  }

  async handleOptionSelection(playerId: string, message: any): Promise<void> {
    if (!this.gameState) return;

    const { selectedNode, stepOrder } = message;
    const step = this.gameState.puzzle.steps[stepOrder - 1];
    const isCorrect = step.correctOption?.node.id === selectedNode.id;

    if (isCorrect) {
      this.gameState.chosenNodes.push(selectedNode);
      this.gameState.currentStep++;
      
      // تحديث نقاط اللاعب
      const player = this.players.get(playerId);
      if (player) {
        player.score += this.calculateScore(stepOrder);
        this.players.set(playerId, player);
      }

      // التحقق من انتهاء اللعبة
      if (this.gameState.currentStep > this.gameState.puzzle.linksCount) {
        this.broadcast({
          type: 'gameCompleted',
          gameState: this.gameState,
          players: Array.from(this.players.values()),
        });
      } else {
        // الانتقال للاعب التالي
        this.gameState.currentPlayerIndex = 
          (this.gameState.currentPlayerIndex + 1) % this.players.size;
        
        this.broadcast({
          type: 'stepCompleted',
          gameState: this.gameState,
          players: Array.from(this.players.values()),
        });
      }
    } else {
      // إجابة خاطئة
      this.broadcast({
        type: 'wrongAnswer',
        playerId,
        gameState: this.gameState,
      });
    }
  }

  sendToPlayer(playerId: string, message: any): void {
    const ws = this.sessions.get(playerId);
    if (ws && ws.readyState === WebSocket.READY_STATE_OPEN) {
      ws.send(JSON.stringify(message));
    }
  }

  broadcast(message: any, excludePlayerId?: string): void {
    for (const [playerId, ws] of this.sessions.entries()) {
      if (playerId !== excludePlayerId && 
          ws.readyState === WebSocket.READY_STATE_OPEN) {
        ws.send(JSON.stringify(message));
      }
    }
  }

  calculateScore(stepOrder: number): number {
    // نفس منطق حساب النقاط من Flutter
    const basePoints = 100;
    const multiplier = this.gameState?.puzzle.linksCount || 1;
    return basePoints * multiplier;
  }

  async loadPuzzle(config: GameConfig): Promise<Puzzle> {
    // يمكن جلب اللغز من:
    // 1. Cloudflare KV (Key-Value store)
    // 2. قاعدة بيانات خارجية
    // 3. ملف JSON مخزن في Worker
    
    // مثال بسيط:
    return {
      id: config.puzzleId,
      linksCount: config.linksCount,
      timeLimit: 120,
      steps: [], // يتم تحميلها من KV
    };
  }
}

// Types
interface GameState {
  puzzle: Puzzle;
  currentStep: number;
  chosenNodes: any[];
  score: number;
  remainingSeconds: number;
  startTime: number;
  currentPlayerIndex: number;
}

interface PlayerInfo {
  id: string;
  name: string;
  isHost: boolean;
  score: number;
}

interface GameConfig {
  puzzleId?: string;
  linksCount: number;
  representationType: string;
  category?: string;
}

interface Puzzle {
  id: string;
  linksCount: number;
  timeLimit: number;
  steps: any[];
}

function generateId(): string {
  return Math.random().toString(36).substring(2, 15);
}
```

---

## الخطوة 3: تكامل Flutter مع Cloudflare

### 3.1 إضافة WebSocket Client

```bash
flutter pub add web_socket_channel
```

### 3.2 إنشاء Multiplayer Service

```dart
// lib/features/multiplayer/data/services/cloudflare_multiplayer_service.dart

import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:async';

class CloudflareMultiplayerService {
  WebSocketChannel? _channel;
  String? _roomId;
  String? _playerId;
  
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();
  
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  Future<void> connectToRoom({
    required String roomId,
    required String playerId,
    required String playerName,
  }) async {
    _roomId = roomId;
    _playerId = playerId;
    
    // استبدل YOUR_WORKER_URL بالرابط الفعلي
    final url = 'wss://mystery-link-backend.YOUR_SUBDOMAIN.workers.dev/game/$roomId?playerId=$playerId&playerName=$playerName';
    
    _channel = WebSocketChannel.connect(Uri.parse(url));
    
    _channel!.stream.listen(
      (message) {
        try {
          final data = jsonDecode(message as String) as Map<String, dynamic>;
          _messageController.add(data);
        } catch (e) {
          print('Error parsing message: $e');
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
        _messageController.add({
          'type': 'error',
          'message': error.toString(),
        });
      },
      onDone: () {
        print('WebSocket closed');
        _messageController.add({'type': 'disconnected'});
      },
    );
  }

  Future<void> sendMessage(Map<String, dynamic> message) async {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(message));
    }
  }

  Future<void> startGame({
    required String representationType,
    required int linksCount,
    String? category,
  }) async {
    await sendMessage({
      'type': 'startGame',
      'config': {
        'representationType': representationType,
        'linksCount': linksCount,
        'category': category,
      },
    });
  }

  Future<void> selectOption({
    required String nodeId,
    required int stepOrder,
  }) async {
    await sendMessage({
      'type': 'selectOption',
      'selectedNode': {'id': nodeId},
      'stepOrder': stepOrder,
    });
  }

  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}
```

### 3.3 تحديث GroupGameBloc لدعم Multiplayer

```dart
// إضافة في GroupGameBloc

final CloudflareMultiplayerService? _multiplayerService;

StreamSubscription? _multiplayerSubscription;

void _setupMultiplayer() {
  if (_multiplayerService != null) {
    _multiplayerSubscription = _multiplayerService!.messageStream.listen(
      (message) {
        switch (message['type']) {
          case 'gameStarted':
            _handleRemoteGameStarted(message);
            break;
          case 'stepCompleted':
            _handleRemoteStepCompleted(message);
            break;
          case 'playerJoined':
            _handlePlayerJoined(message);
            break;
          // ... معالجة باقي الرسائل
        }
      },
    );
  }
}

void _handleRemoteGameStarted(Map<String, dynamic> message) {
  final gameState = message['gameState'];
  // تحديث حالة اللعبة من الخادم
  // ...
}
```

---

## الخطوة 4: النشر على Cloudflare

### 4.1 نشر Worker

```bash
# تسجيل الدخول
wrangler login

# نشر المشروع
wrangler deploy
```

### 4.2 إعداد Custom Domain (اختياري)

```bash
# إضافة domain
wrangler route add "api.mysterylink.com/*"
```

---

## الخطوة 5: تحسينات إضافية

### 5.1 استخدام Cloudflare KV لتخزين الألغاز

```typescript
// في wrangler.toml
[[kv_namespaces]]
binding = "PUZZLES"
id = "your-kv-namespace-id"

// في GameRoom.ts
async loadPuzzle(config: GameConfig): Promise<Puzzle> {
  const puzzleKey = `puzzle:${config.puzzleId}`;
  const puzzleData = await this.env.PUZZLES.get(puzzleKey);
  return JSON.parse(puzzleData || '{}');
}
```

### 5.2 إضافة Authentication

```typescript
// التحقق من JWT token قبل قبول الاتصال
async handleSession(ws: WebSocket, request: Request): Promise<void> {
  const token = new URL(request.url).searchParams.get('token');
  if (!await this.verifyToken(token)) {
    ws.close(1008, 'Unauthorized');
    return;
  }
  // ... باقي الكود
}
```

### 5.3 Rate Limiting

```typescript
// استخدام Durable Objects للـ rate limiting
const rateLimiter = env.RATE_LIMITER.get(
  env.RATE_LIMITER.idFromName(playerId)
);
const allowed = await rateLimiter.checkLimit();
```

---

## التكاليف المقدرة

### Cloudflare Workers (Free Tier):
- ✅ 100,000 request/day مجاناً
- ✅ 10ms CPU time per request
- ✅ Durable Objects: 1M requests/month مجاناً

### للاستخدام المتوسط:
- **100 لاعب نشط يومياً**: مجاني تماماً
- **1000+ لاعب**: ~$5-10/شهر

---

## الخطوات التالية

1. ✅ إنشاء Cloudflare Worker project
2. ✅ تنفيذ GameRoom Durable Object
3. ✅ إضافة WebSocket handling
4. ✅ تكامل Flutter app
5. ✅ اختبار الاتصال المحلي
6. ✅ نشر على Cloudflare
7. ✅ اختبار مع لاعبين حقيقيين

---

## موارد إضافية

- [Cloudflare Workers Docs](https://developers.cloudflare.com/workers/)
- [Durable Objects Guide](https://developers.cloudflare.com/durable-objects/)
- [WebSocket API](https://developers.cloudflare.com/workers/learning/using-websockets/)

---

## ملاحظات مهمة

1. **Latency**: Cloudflare Workers تعمل على حافة الشبكة، مما يقلل التأخير
2. **Scaling**: كل غرفة لعبة = Durable Object واحد (مثالي للعبة turn-based)
3. **State**: Durable Objects تحتفظ بالحالة في الذاكرة (سريع جداً)
4. **Persistence**: للبيانات الدائمة، استخدم KV أو قاعدة بيانات خارجية

---

تم إعداد هذا الدليل بناءً على إمكانيات Cloudflare الحالية (2025). النظام جاهز للتنفيذ والتجربة! 🚀

