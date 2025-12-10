# دليل البدء السريع

## 1. التثبيت

```bash
npm install
```

## 2. التطوير المحلي

```bash
npm run dev
```

الخادم سيعمل على `http://localhost:8787`

## 3. اختبار الاتصال

### إنشاء غرفة:
```bash
curl http://localhost:8787/api/create-room
```

### الاتصال عبر WebSocket:
استخدم أداة مثل [WebSocket King](https://websocketking.com/) أو كود Flutter:

```dart
final channel = WebSocketChannel.connect(
  Uri.parse('ws://localhost:8787/game/1234?playerId=player1&playerName=Player%201'),
);
```

## 4. النشر على Cloudflare

```bash
# تسجيل الدخول
wrangler login

# نشر
npm run deploy
```

## 5. اختبار بعد النشر

استبدل `localhost:8787` بـ URL الخاص بك:
```
https://mystery-link-backend.YOUR_SUBDOMAIN.workers.dev
```

---

**ملاحظة**: تأكد من تحديث `baseUrl` في Flutter app بعد النشر!

