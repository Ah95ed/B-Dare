# دليل النشر على Cloudflare - خطوة بخطوة

## 📋 ما سترفعه على Cloudflare

### الملفات المطلوبة:

```
backend/
├── src/
│   ├── index.ts          ✅ (يُرفع)
│   └── GameRoom.ts       ✅ (يُرفع)
├── package.json          ✅ (يُرفع)
├── wrangler.toml         ✅ (يُرفع)
├── tsconfig.json         ✅ (يُرفع)
└── node_modules/         ❌ (لا يُرفع - يتم تثبيته تلقائياً)
```

**ملاحظة**: Cloudflare Workers سيقوم ببناء المشروع تلقائياً، لا حاجة لرفع `node_modules` أو ملفات البناء.

---

## 🚀 خطوات النشر

### الخطوة 1: التحضير

```bash
# الانتقال لمجلد backend
cd backend

# التأكد من تثبيت dependencies
npm install
```

### الخطوة 2: تسجيل الدخول في Cloudflare

```bash
# تسجيل الدخول (يفتح متصفح)
wrangler login
```

**ماذا يحدث؟**
- سيفتح متصفحك تلقائياً
- ستدخل إلى حساب Cloudflare (أو تنشئ حساب جديد مجاناً)
- سيتم تفعيل Wrangler CLI

### الخطوة 3: النشر

```bash
# نشر المشروع
wrangler deploy
```

**ماذا يحدث؟**
- ✅ بناء المشروع (TypeScript → JavaScript)
- ✅ رفع الملفات إلى Cloudflare
- ✅ إنشاء Durable Objects
- ✅ تفعيل Worker

**النتيجة:**
```
✨ Deployment complete!
🌍 https://mystery-link-backend.YOUR_ACCOUNT.workers.dev
```

---

## 🔧 الإعدادات المهمة

### 1. تحديث `wrangler.toml` (اختياري)

إذا أردت تغيير اسم المشروع:

```toml
name = "mystery-link-backend"  # يمكن تغييره
```

### 2. الحصول على URL الخاص بك

بعد النشر، ستحصل على URL مثل:
```
https://mystery-link-backend.YOUR_SUBDOMAIN.workers.dev
```

**احفظ هذا الـ URL!** ستحتاجه في Flutter app.

---

## ✅ التحقق من النشر

### 1. اختبار Health Check:

```bash
curl https://YOUR_WORKER_URL.workers.dev/health
```

**النتيجة المتوقعة:**
```json
{"status":"ok","timestamp":1234567890}
```

### 2. اختبار إنشاء غرفة:

```bash
curl https://YOUR_WORKER_URL.workers.dev/api/create-room
```

**النتيجة المتوقعة:**
```json
{
  "roomId": "1234",
  "wsUrl": "wss://YOUR_WORKER_URL.workers.dev/game/1234"
}
```

### 3. اختبار WebSocket (استخدم أداة مثل Postman أو WebSocket King):

```
wss://YOUR_WORKER_URL.workers.dev/game/1234?playerId=test&playerName=Test%20Player
```

---

## 🔄 تحديث Flutter App

بعد النشر، حدّث `CloudflareMultiplayerService`:

### الطريقة 1: تحديث مباشر في الكود

```dart
// في lib/features/multiplayer/data/services/cloudflare_multiplayer_service.dart
class CloudflareMultiplayerService {
  // ...
  CloudflareMultiplayerService({String? baseUrl}) 
      : _baseUrl = baseUrl ?? 'wss://YOUR_WORKER_URL.workers.dev';  // ← غيّر هنا
}
```

### الطريقة 2: استخدام Environment Variables (موصى به)

```dart
// في lib/core/constants/app_constants.dart
class AppConstants {
  // ...
  static const String cloudflareWorkerUrl = 'wss://YOUR_WORKER_URL.workers.dev';
}

// في CloudflareMultiplayerService
CloudflareMultiplayerService({String? baseUrl}) 
    : _baseUrl = baseUrl ?? AppConstants.cloudflareWorkerUrl;
```

---

## 📊 المراقبة والـ Logs

### مشاهدة الـ Logs:

```bash
wrangler tail
```

**ماذا ترى:**
- جميع الطلبات الواردة
- الأخطاء (إن وجدت)
- WebSocket connections
- Console.log messages

### Dashboard:

1. اذهب إلى [Cloudflare Dashboard](https://dash.cloudflare.com)
2. اختر Workers & Pages
3. اختر مشروعك
4. شاهد:
   - عدد الطلبات
   - الأخطاء
   - الاستخدام
   - التكاليف

---

## 🐛 استكشاف الأخطاء

### المشكلة: "Failed to deploy"

**الحل:**
```bash
# تحقق من الأخطاء
npm run build  # إذا كان موجوداً

# أو
wrangler deploy --dry-run
```

### المشكلة: "Durable Objects not found"

**الحل:**
- تأكد من وجود `[[migrations]]` في `wrangler.toml`
- تأكد من أن `class_name` يطابق اسم الكلاس في `GameRoom.ts`

### المشكلة: "WebSocket connection failed"

**الحل:**
- تأكد من استخدام `wss://` (ليس `ws://`)
- تأكد من أن URL صحيح
- تحقق من CORS headers

---

## 💰 التكاليف

### Free Tier (مجاني):
- ✅ 100,000 request/يوم
- ✅ 10ms CPU time/request
- ✅ 1M Durable Object requests/شهر

### Paid (إذا تجاوزت):
- 💰 $5/شهر للـ Workers (10M requests)
- 💰 $0.15/M Durable Object requests

**للاستخدام المتوسط (100-1000 لاعب/يوم): مجاني تماماً!**

---

## 📝 Checklist قبل النشر

- [ ] `npm install` تم بنجاح
- [ ] `wrangler login` تم بنجاح
- [ ] جميع الملفات موجودة (`index.ts`, `GameRoom.ts`)
- [ ] `wrangler.toml` صحيح
- [ ] جاهز لتحديث Flutter app بالـ URL الجديد

---

## 🎯 بعد النشر

1. ✅ احفظ الـ URL
2. ✅ حدّث Flutter app
3. ✅ اختبر الاتصال
4. ✅ راقب الـ logs
5. ✅ اختبر مع لاعبين حقيقيين

---

## 📚 موارد إضافية

- [Cloudflare Workers Docs](https://developers.cloudflare.com/workers/)
- [Wrangler CLI Docs](https://developers.cloudflare.com/workers/wrangler/)
- [Durable Objects Guide](https://developers.cloudflare.com/durable-objects/)

---

**جاهز للنشر!** 🚀

