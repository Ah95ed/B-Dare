# 🚀 دليل النشر على Cloudflare - خطوة بخطوة

## 📦 ماذا ترفع على Cloudflare؟

### ✅ الملفات المطلوبة (في مجلد `backend/`):

```
backend/
├── src/
│   ├── index.ts          ✅ (يُرفع تلقائياً)
│   └── GameRoom.ts       ✅ (يُرفع تلقائياً)
├── package.json          ✅ (يُرفع تلقائياً)
├── wrangler.toml         ✅ (يُرفع تلقائياً)
└── tsconfig.json         ✅ (يُرفع تلقائياً)
```

**ملاحظة مهمة**: Wrangler CLI سيرفع هذه الملفات تلقائياً عند تشغيل `wrangler deploy`. **لا حاجة لرفع يدوي!**

### ❌ لا ترفع (يتم تجاهلها تلقائياً):

- `node_modules/` - يتم تثبيته على Cloudflare
- `.wrangler/` - ملفات مؤقتة
- `.git/` - ملفات Git
- `.env` - ملفات حساسة

---

## 🎯 ماذا تفعل؟ (3 خطوات فقط)

### الخطوة 1: فتح Terminal والانتقال للمجلد

```bash
cd backend
```

### الخطوة 2: تثبيت Dependencies (مرة واحدة فقط)

```bash
npm install
```

**النتيجة المتوقعة:**
```
added 60 packages
```

### الخطوة 3: النشر!

```bash
# أولاً: تسجيل الدخول (مرة واحدة فقط)
wrangler login

# ثم: النشر
wrangler deploy
```

**ماذا يحدث عند `wrangler login`؟**
- يفتح المتصفح تلقائياً
- تسجيل الدخول في Cloudflare (أو إنشاء حساب مجاني)
- تفعيل Wrangler CLI

**ماذا يحدث عند `wrangler deploy`？**
1. ✅ بناء المشروع (TypeScript → JavaScript)
2. ✅ رفع الملفات تلقائياً
3. ✅ إنشاء Durable Objects
4. ✅ تفعيل Worker

**النتيجة:**
```
✨ Deployment complete!
🌍 https://mystery-link-backend.YOUR_SUBDOMAIN.workers.dev
```

**احفظ هذا الـ URL!** ستحتاجه في الخطوة التالية.

---

## 🔧 بعد النشر: تحديث Flutter App

### 1. افتح الملف:
```
lib/core/constants/app_constants.dart
```

### 2. حدّث الـ URLs:

```dart
// استبدل YOUR_SUBDOMAIN بالـ URL الفعلي الذي حصلت عليه
static const String cloudflareWorkerUrl = 'wss://mystery-link-backend.YOUR_ACTUAL_SUBDOMAIN.workers.dev';
static const String cloudflareWorkerHttpUrl = 'https://mystery-link-backend.YOUR_ACTUAL_SUBDOMAIN.workers.dev';
```

**مثال:**
إذا كان URL هو `https://mystery-link-backend.abc123.workers.dev`:

```dart
static const String cloudflareWorkerUrl = 'wss://mystery-link-backend.abc123.workers.dev';
static const String cloudflareWorkerHttpUrl = 'https://mystery-link-backend.abc123.workers.dev';
```

---

## ✅ اختبار النشر

### 1. Health Check:

```bash
curl https://YOUR_URL.workers.dev/health
```

**النتيجة المتوقعة:**
```json
{"status":"ok","timestamp":1234567890}
```

### 2. إنشاء غرفة:

```bash
curl https://YOUR_URL.workers.dev/api/create-room
```

**النتيجة المتوقعة:**
```json
{
  "roomId": "1234",
  "wsUrl": "wss://YOUR_URL.workers.dev/game/1234"
}
```

### 3. من Flutter App:

- افتح التطبيق
- جرب إنشاء غرفة (إذا كان لديك UI)
- أو استخدم الكود مباشرة

---

## 📊 المراقبة

### مشاهدة الـ Logs:

```bash
wrangler tail
```

### Dashboard:

1. اذهب إلى [dash.cloudflare.com](https://dash.cloudflare.com)
2. Workers & Pages
3. اختر مشروعك
4. شاهد الإحصائيات

---

## 🐛 استكشاف الأخطاء

### خطأ: "wrangler: command not found"

**الحل:**
```bash
npm install -g wrangler
```

### خطأ: "Failed to deploy"

**الحل:**
```bash
# تحقق من الأخطاء
wrangler deploy --dry-run
```

### خطأ: "WebSocket connection failed"

**الحل:**
- تأكد من استخدام `wss://` (ليس `ws://`)
- تأكد من تحديث URL في `app_constants.dart`

---

## 💰 التكاليف

### Free Tier (مجاني تماماً):
- ✅ 100,000 request/يوم
- ✅ 1M Durable Object requests/شهر
- ✅ **كافي لـ 100+ لاعب نشط يومياً**

### Paid (إذا تجاوزت):
- 💰 $5/شهر للـ Workers
- 💰 $0.15/M Durable Object requests

---

## 📝 ملخص سريع

```bash
# 1. الانتقال للمجلد
cd backend

# 2. تثبيت (مرة واحدة)
npm install

# 3. تسجيل الدخول (مرة واحدة)
wrangler login

# 4. النشر
wrangler deploy

# 5. احفظ الـ URL وحدّث Flutter app
```

---

## 🎯 Checklist

- [ ] `cd backend` ✅
- [ ] `npm install` ✅
- [ ] `wrangler login` ✅
- [ ] `wrangler deploy` ✅
- [ ] حصلت على URL ✅
- [ ] حدّثت `app_constants.dart` ✅
- [ ] اختبرت Health Check ✅
- [ ] اختبرت Create Room ✅

---

## 📚 ملفات مرجعية

- `backend/DEPLOYMENT_GUIDE.md` - دليل شامل مفصل
- `docs/CLOUDFLARE_DEPLOYMENT_STEPS.md` - خطوات سريعة
- `docs/FINAL_DEPLOYMENT_CHECKLIST.md` - قائمة تحقق

---

**جاهز للنشر! ابدأ الآن!** 🚀

