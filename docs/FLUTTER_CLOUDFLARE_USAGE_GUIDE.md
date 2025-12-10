# 🎮 دليل استخدام Cloudflare Backend مع Flutter

**تاريخ التحديث:** 4 ديسمبر 2025  
**URL:** `https://mystery-link-backend.dent19900.workers.dev`

---

## 📋 نظرة عامة

تم ربط Flutter App بـ Cloudflare Backend بنجاح. هذا الدليل يوضح كيفية استخدامه بشكل فعلي في التطبيق.

---

## ✅ ما تم إعداده بالفعل

1. ✅ **CloudflareMultiplayerService** - جاهز للاستخدام
2. ✅ **AppConstants** - محدث بالـ URL الجديد
3. ✅ **GroupGameBloc** - يدعم Multiplayer
4. ✅ **TournamentService** - متصل بـ Cloudflare

---

## 🚀 طرق الاستخدام

### **1. إنشاء غرفة لعبة جماعية**

#### في `create_group_screen.dart`:

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/constants/app_constants.dart';
import '../../../../features/multiplayer/data/services/cloudflare_multiplayer_service.dart';

// 1. إنشاء غرفة جديدة
final response = await http.post(
  Uri.parse('${AppConstants.cloudflareWorkerHttpUrl}/api/create-room'),
  headers: {'Content-Type': 'application/json'},
);

if (response.statusCode == 200) {
  final data = jsonDecode(response.body);
  final roomId = data['roomId'] as String;
  final wsUrl = data['wsUrl'] as String;
  
  // 2. إنشاء CloudflareMultiplayerService
  final multiplayerService = CloudflareMultiplayerService(
    baseUrl: AppConstants.cloudflareWorkerUrl,
  );
  
  // 3. الاتصال بالغرفة
  await multiplayerService.connectToRoom(
    roomId: roomId,
    playerId: playerId,
    playerName: playerName,
  );
  
  // 4. الانتقال إلى شاشة اللعبة
  Navigator.pushNamed(
    context,
    AppRouter.game,
    arguments: {
      'gameMode': 'group',
      'cloudflareRoomId': roomId,
      'multiplayerService': multiplayerService,
      // ... other params
    },
  );
}
```

---

### **2. الانضمام إلى غرفة موجودة**

```dart
// إذا كان لديك roomId (من QR code أو رابط)
final multiplayerService = CloudflareMultiplayerService(
  baseUrl: AppConstants.cloudflareWorkerUrl,
);

await multiplayerService.connectToRoom(
  roomId: existingRoomId,
  playerId: playerId,
  playerName: playerName,
);

// الانتقال إلى اللعبة
Navigator.pushNamed(
  context,
  AppRouter.game,
  arguments: {
    'gameMode': 'group',
    'cloudflareRoomId': existingRoomId,
    'multiplayerService': multiplayerService,
  },
);
```

---

### **3. بدء اللعبة (من Host)**

```dart
// في GroupGameBloc أو GameScreen
await multiplayerService.startGame(
  representationType: 'text', // أو 'image', 'audio'
  linksCount: 5,
  category: 'General Knowledge',
  puzzleId: 'puzzle_123',
);
```

---

### **4. إرسال إجابة**

```dart
// عندما يختار اللاعب إجابة
await multiplayerService.sendAnswer(
  nodeId: selectedNodeId,
  optionIndex: selectedOptionIndex,
);
```

---

### **5. الاستماع للرسائل من الخادم**

```dart
// في GroupGameBloc أو GameScreen
multiplayerService.messageStream.listen((message) {
  switch (message.type) {
    case 'gameStarted':
      // اللعبة بدأت
      final puzzle = message.data['puzzle'];
      // تحديث الحالة
      break;
      
    case 'playerJoined':
      // لاعب جديد انضم
      final player = message.data['player'];
      // تحديث قائمة اللاعبين
      break;
      
    case 'playerLeft':
      // لاعب غادر
      final playerId = message.data['playerId'];
      // تحديث قائمة اللاعبين
      break;
      
    case 'answerReceived':
      // لاعب أرسل إجابة
      final playerId = message.data['playerId'];
      final nodeId = message.data['nodeId'];
      // تحديث الحالة
      break;
      
    case 'gameStateUpdate':
      // تحديث حالة اللعبة
      final gameState = message.data['gameState'];
      // تحديث الحالة
      break;
      
    case 'gameEnded':
      // اللعبة انتهت
      final results = message.data['results'];
      // الانتقال إلى شاشة النتائج
      break;
      
    case 'error':
      // خطأ
      final errorMessage = message.data['message'];
      // عرض رسالة خطأ
      break;
      
    case 'disconnected':
      // انقطع الاتصال
      // محاولة إعادة الاتصال
      break;
  }
});
```

---

## 🎯 أمثلة عملية كاملة

### **مثال 1: إنشاء غرفة والبدء**

```dart
class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  CloudflareMultiplayerService? _multiplayerService;
  String? _roomId;
  
  Future<void> _createRoom() async {
    try {
      // 1. إنشاء غرفة
      final response = await http.post(
        Uri.parse('${AppConstants.cloudflareWorkerHttpUrl}/api/create-room'),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _roomId = data['roomId'] as String;
        
        // 2. إنشاء Service
        _multiplayerService = CloudflareMultiplayerService(
          baseUrl: AppConstants.cloudflareWorkerUrl,
        );
        
        // 3. الاتصال
        await _multiplayerService!.connectToRoom(
          roomId: _roomId!,
          playerId: 'host_${DateTime.now().millisecondsSinceEpoch}',
          playerName: 'Host Player',
        );
        
        // 4. الانتقال إلى اللعبة
        if (mounted) {
          Navigator.pushNamed(
            context,
            AppRouter.game,
            arguments: {
              'gameMode': 'group',
              'cloudflareRoomId': _roomId,
              'multiplayerService': _multiplayerService,
            },
          );
        }
      }
    } catch (e) {
      // معالجة الخطأ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _createRoom,
          child: Text('Create Room'),
        ),
      ),
    );
  }
}
```

---

### **مثال 2: استخدام في GroupGameBloc**

```dart
class GroupGameBloc extends BaseGameBloc {
  final CloudflareMultiplayerService? _multiplayerService;
  
  GroupGameBloc({
    // ... other params
    CloudflareMultiplayerService? multiplayerService,
  }) : _multiplayerService = multiplayerService {
    // الاستماع للرسائل
    _multiplayerService?.messageStream.listen(_handleMessage);
  }
  
  void _handleMessage(MultiplayerMessage message) {
    switch (message.type) {
      case 'gameStarted':
        final puzzle = Puzzle.fromJson(message.data['puzzle']);
        add(LoadPuzzleEvent(puzzle: puzzle));
        break;
        
      case 'answerReceived':
        final playerId = message.data['playerId'];
        final nodeId = message.data['nodeId'];
        final optionIndex = message.data['optionIndex'];
        // تحديث الحالة
        break;
        
      case 'gameStateUpdate':
        // تحديث حالة اللعبة
        break;
    }
  }
  
  Future<void> startGame() async {
    await _multiplayerService?.startGame(
      representationType: 'text',
      linksCount: 5,
    );
  }
  
  Future<void> submitAnswer(String nodeId, int optionIndex) async {
    await _multiplayerService?.sendAnswer(
      nodeId: nodeId,
      optionIndex: optionIndex,
    );
  }
}
```

---

### **مثال 3: معالجة الأخطاء وإعادة الاتصال**

```dart
class GameScreen extends StatefulWidget {
  final CloudflareMultiplayerService multiplayerService;
  final String roomId;
  
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  StreamSubscription? _messageSubscription;
  bool _isConnected = true;
  
  @override
  void initState() {
    super.initState();
    _setupMessageListener();
  }
  
  void _setupMessageListener() {
    _messageSubscription = widget.multiplayerService.messageStream.listen(
      (message) {
        if (message.type == 'disconnected') {
          setState(() => _isConnected = false);
          _attemptReconnect();
        } else if (message.type == 'connected') {
          setState(() => _isConnected = true);
        }
      },
    );
  }
  
  Future<void> _attemptReconnect() async {
    // محاولة إعادة الاتصال كل 3 ثواني
    await Future.delayed(Duration(seconds: 3));
    
    try {
      await widget.multiplayerService.connectToRoom(
        roomId: widget.roomId,
        playerId: widget.multiplayerService.playerId ?? 'player',
        playerName: 'Player',
      );
    } catch (e) {
      // إعادة المحاولة
      _attemptReconnect();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // محتوى اللعبة
          GameContent(),
          
          // مؤشر الاتصال
          if (!_isConnected)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.orange,
                padding: EdgeInsets.all(8),
                child: Text(
                  'Reconnecting...',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }
}
```

---

## 🔍 API Endpoints المتاحة

### **1. Health Check**
```dart
final response = await http.get(
  Uri.parse('${AppConstants.cloudflareWorkerHttpUrl}/health'),
);
// Response: {"status":"ok","timestamp":1234567890}
```

### **2. Create Room**
```dart
final response = await http.post(
  Uri.parse('${AppConstants.cloudflareWorkerHttpUrl}/api/create-room'),
);
// Response: {"roomId":"1234","wsUrl":"wss://..."}
```

### **3. Get Room Info**
```dart
final response = await http.get(
  Uri.parse('${AppConstants.cloudflareWorkerHttpUrl}/api/room/$roomId'),
);
// Response: {"roomId":"1234","status":"active","players":[...]}
```

---

## 📱 أنواع الرسائل (Messages)

### **الرسائل المرسلة من Flutter:**

1. **startGame**
```dart
{
  "type": "startGame",
  "config": {
    "representationType": "text",
    "linksCount": 5,
    "category": "General Knowledge",
    "puzzleId": "puzzle_123"
  }
}
```

2. **sendAnswer**
```dart
{
  "type": "sendAnswer",
  "nodeId": "node_1",
  "optionIndex": 0
}
```

3. **playerReady**
```dart
{
  "type": "playerReady"
}
```

---

### **الرسائل الواردة من Cloudflare:**

1. **connected** - تم الاتصال
2. **gameStarted** - اللعبة بدأت
3. **playerJoined** - لاعب انضم
4. **playerLeft** - لاعب غادر
5. **answerReceived** - إجابة وردت
6. **gameStateUpdate** - تحديث الحالة
7. **gameEnded** - اللعبة انتهت
8. **error** - خطأ
9. **disconnected** - انقطع الاتصال

---

## 🐛 استكشاف الأخطاء

### **المشكلة: "Connection failed"**

**الحل:**
```dart
// تأكد من استخدام wss:// (ليس ws://)
final service = CloudflareMultiplayerService(
  baseUrl: AppConstants.cloudflareWorkerUrl, // wss://...
);
```

### **المشكلة: "Room not found"**

**الحل:**
```dart
// تأكد من إنشاء الغرفة أولاً
final response = await http.post(
  Uri.parse('${AppConstants.cloudflareWorkerHttpUrl}/api/create-room'),
);
final roomId = jsonDecode(response.body)['roomId'];
```

### **المشكلة: "WebSocket closed"**

**الحل:**
```dart
// Service يدعم إعادة الاتصال تلقائياً
// أو يمكنك إعادة الاتصال يدوياً:
await multiplayerService.connectToRoom(
  roomId: roomId,
  playerId: playerId,
  playerName: playerName,
);
```

---

## ✅ Checklist للاستخدام

- [ ] تأكد من تحديث `AppConstants.cloudflareWorkerUrl`
- [ ] استخدم `CloudflareMultiplayerService` لإنشاء الاتصال
- [ ] استمع لـ `messageStream` لاستقبال الرسائل
- [ ] استخدم `startGame()` لبدء اللعبة
- [ ] استخدم `sendAnswer()` لإرسال الإجابات
- [ ] عالج الأخطاء و `disconnected` events
- [ ] اختبر الاتصال قبل النشر

---

## 🎉 الخلاصة

✅ **كل شيء جاهز!**  
✅ **CloudflareMultiplayerService يعمل**  
✅ **URL محدث في AppConstants**  
✅ **جاهز للاستخدام الفعلي**

---

**تاريخ التحديث:** 4 ديسمبر 2025  
**URL:** `https://mystery-link-backend.dent19900.workers.dev`

