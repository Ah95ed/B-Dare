# خطوات النشر على Cloudflare - دليل سريع

## 🎯 الهدف

نشر Backend على Cloudflare Workers لتفعيل اللعب الجماعي المزامن.

---

## 📦 ما سترفعه

### ✅ الملفات المطلوبة (في مجلد `backend/`):

1. **`src/index.ts`** - Entry point
2. **`src/GameRoom.ts`** - Durable Object
3. **`package.json`** - Dependencies
4. **`wrangler.toml`** - Configuration
5. **`tsconfig.json`** - TypeScript config

### ❌ لا ترفع:

- `node_modules/` (يتم تثبيته تلقائياً)
- `.wrangler/` (ملفات مؤقتة)
- `.env` (ملفات حساسة)

---

## 🚀 الخطوات (5 دقائق)

### 1️⃣ التحضير

```bash
cd backend
npm install
```

### 2️⃣ تسجيل الدخول

```bash
wrangler login
```

**ماذا يحدث؟**
- يفتح المتصفح
- تسجيل الدخول في Cloudflare (أو إنشاء حساب مجاني)
- تفعيل Wrangler

### 3️⃣ النشر

```bash
wrangler deploy
```

**النتيجة:**
```
✨ Deployment complete!
🌍 https://mystery-link-backend.YOUR_SUBDOMAIN.workers.dev
```

### 4️⃣ اختبار

```bash
# Health check
curl https://YOUR_WORKER_URL.workers.dev/health

# إنشاء غرفة
curl https://YOUR_WORKER_URL.workers.dev/api/create-room
```

---

## 🔧 تحديث Flutter App

بعد النشر، احصل على URL وحدّث:

```dart
// في lib/core/constants/app_constants.dart
static const String cloudflareWorkerUrl = 'wss://YOUR_WORKER_URL.workers.dev';
```

---

## 📊 المراقبة

```bash
# مشاهدة الـ logs
wrangler tail
```

أو من [Cloudflare Dashboard](https://dash.cloudflare.com)

---

## ✅ Checklist

- [ ] `npm install` ✅
- [ ] `wrangler login` ✅
- [ ] `wrangler deploy` ✅
- [ ] حصلت على URL ✅
- [ ] حدّثت Flutter app ✅
- [ ] اختبرت الاتصال ✅

---

**جاهز!** 🎉

