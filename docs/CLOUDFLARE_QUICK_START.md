# دليل البدء السريع: Cloudflare Multiplayer

## نظرة عامة سريعة

هذا دليل مختصر لبدء تنفيذ اللعب الجماعي المزامن على Cloudflare في أقل وقت ممكن.

---

## المتطلبات الأساسية

```bash
# تثبيت Node.js (v18+)
node --version

# تثبيت Wrangler CLI
npm install -g wrangler

# تسجيل الدخول في Cloudflare
wrangler login
```

---

## خطوات التنفيذ (5 دقائق)

### 1. إنشاء المشروع

```bash
mkdir mystery-link-backend
cd mystery-link-backend
npm init -y
npm install -D wrangler typescript @cloudflare/workers-types
```

### 2. ملف `wrangler.toml`

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

### 3. ملف `src/index.ts`

```typescript
export interface Env {
  GAME_ROOM: DurableObjectNamespace;
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);
    
    if (url.pathname.startsWith('/game/')) {
      const roomId = url.pathname.split('/')[2];
      const id = env.GAME_ROOM.idFromName(roomId);
      const stub = env.GAME_ROOM.get(id);
      return stub.fetch(request);
    }
    
    return new Response('Mystery Link Backend', { status: 200 });
  },
};
```

### 4. ملف `src/GameRoom.ts`

```typescript
export class GameRoom implements DurableObject {
  private state: DurableObjectState;
  private sessions: Map<string, WebSocket> = new Map();

  constructor(state: DurableObjectState, env: any) {
    this.state = state;
  }

  async fetch(request: Request): Promise<Response> {
    const upgradeHeader = request.headers.get('Upgrade');
    if (upgradeHeader !== 'websocket') {
      return new Response('Expected WebSocket', { status: 426 });
    }

    const pair = new WebSocketPair();
    const [client, server] = Object.values(pair);
    
    server.accept();
    this.sessions.set('player1', server);
    
    server.addEventListener('message', (event) => {
      console.log('Received:', event.data);
      server.send(JSON.stringify({ type: 'echo', data: event.data }));
    });

    return new Response(null, {
      status: 101,
      webSocket: client,
    });
  }
}
```

### 5. النشر

```bash
wrangler deploy
```

---

## اختبار الاتصال

### من Flutter:

```dart
import 'package:web_socket_channel/web_socket_channel.dart';

final channel = WebSocketChannel.connect(
  Uri.parse('wss://mystery-link-backend.YOUR_SUBDOMAIN.workers.dev/game/ROOM123'),
);

channel.sink.add('{"type": "test"}');
channel.stream.listen((message) {
  print('Received: $message');
});
```

---

## الخطوات التالية

1. راجع `docs/CLOUDFLARE_MULTIPLAYER_GUIDE.md` للتنفيذ الكامل
2. أضف معالجة الرسائل (startGame, selectOption, etc.)
3. أضف إدارة حالة اللعبة
4. أضف مزامنة اللاعبين

---

## نصائح

- ✅ ابدأ بسيطاً ثم أضف الميزات تدريجياً
- ✅ اختبر محلياً أولاً: `wrangler dev`
- ✅ استخدم `wrangler tail` لمتابعة الـ logs
- ✅ راجع [Cloudflare Dashboard](https://dash.cloudflare.com) للمراقبة

---

**جاهز للبدء!** 🚀

