# ⚡ استخدام Cloudflare مع Flutter - دليل سريع

**URL:** `https://mystery-link-backend.dent19900.workers.dev`

---

## 🚀 3 خطوات للبدء

### **1. إنشاء غرفة**

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/constants/app_constants.dart';
import '../../../../features/multiplayer/data/services/cloudflare_multiplayer_service.dart';

// إنشاء غرفة
final response = await http.post(
  Uri.parse('${AppConstants.cloudflareWorkerHttpUrl}/api/create-room'),
);

final data = jsonDecode(response.body);
final roomId = data['roomId'] as String;
```

### **2. الاتصال بالغرفة**

```dart
// إنشاء Service
final multiplayerService = CloudflareMultiplayerService(
  baseUrl: AppConstants.cloudflareWorkerUrl,
);

// الاتصال
await multiplayerService.connectToRoom(
  roomId: roomId,
  playerId: 'player_1',
  playerName: 'Player 1',
);
```

### **3. الاستماع للرسائل**

```dart
multiplayerService.messageStream.listen((message) {
  switch (message.type) {
    case 'gameStarted':
      // اللعبة بدأت
      break;
    case 'playerJoined':
      // لاعب انضم
      break;
    case 'answerReceived':
      // إجابة وردت
      break;
  }
});
```

---

## 📤 إرسال رسائل

### **بدء اللعبة:**
```dart
await multiplayerService.startGame(
  representationType: 'text',
  linksCount: 5,
);
```

### **إرسال إجابة:**
```dart
await multiplayerService.sendAnswer(
  nodeId: 'node_1',
  optionIndex: 0,
);
```

---

## 📥 أنواع الرسائل الواردة

- `connected` - تم الاتصال
- `gameStarted` - اللعبة بدأت
- `playerJoined` - لاعب انضم
- `playerLeft` - لاعب غادر
- `answerReceived` - إجابة وردت
- `gameStateUpdate` - تحديث الحالة
- `gameEnded` - اللعبة انتهت
- `error` - خطأ
- `disconnected` - انقطع الاتصال

---

## ✅ مثال كامل

```dart
// 1. إنشاء غرفة
final response = await http.post(
  Uri.parse('${AppConstants.cloudflareWorkerHttpUrl}/api/create-room'),
);
final roomId = jsonDecode(response.body)['roomId'];

// 2. إنشاء Service والاتصال
final service = CloudflareMultiplayerService();
await service.connectToRoom(
  roomId: roomId,
  playerId: 'player_1',
  playerName: 'Player 1',
);

// 3. الاستماع
service.messageStream.listen((msg) {
  print('Received: ${msg.type}');
});

// 4. بدء اللعبة
await service.startGame(
  representationType: 'text',
  linksCount: 5,
);
```

---

## 🔍 API Endpoints

- `GET /health` - Health check
- `POST /api/create-room` - إنشاء غرفة
- `GET /api/room/:roomId` - معلومات الغرفة

---

**الدليل الكامل:** `docs/FLUTTER_CLOUDFLARE_USAGE_GUIDE.md`

