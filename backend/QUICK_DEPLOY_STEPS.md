# ⚡ خطوات النشر السريعة - Cloudflare (3 دقائق)

**تاريخ التحديث:** 3 ديسمبر 2025

---

## 🚀 النشر السريع (3 خطوات فقط)

### الخطوة 1: التحضير
```bash
cd backend
npm install
```

### الخطوة 2: تسجيل الدخول (مرة واحدة فقط)
```bash
wrangler login
```

### الخطوة 3: النشر
```bash
wrangler deploy
```

**النتيجة:**
```
✨ Deployment complete!
🌍 https://mystery-link-backend.YOUR_SUBDOMAIN.workers.dev
```

---

## 📝 بعد النشر

### 1. احفظ URL
```
https://YOUR_URL.workers.dev
```

### 2. حدّث Flutter App

في `lib/core/constants/app_constants.dart`:

```dart
static const String cloudflareWorkerUrl = 'wss://YOUR_URL.workers.dev';
static const String cloudflareWorkerHttpUrl = 'https://YOUR_URL.workers.dev';
```

### 3. اختبر

```bash
# Health check
curl https://YOUR_URL.workers.dev/health

# Create room
curl https://YOUR_URL.workers.dev/api/create-room
```

---

## ✅ الملفات التي تُرفع تلقائياً

Wrangler يرفع تلقائياً:
- ✅ `wrangler.toml`
- ✅ `package.json`
- ✅ `tsconfig.json`
- ✅ `src/index.ts`
- ✅ `src/GameRoom.ts`
- ✅ `src/TournamentRoom.ts`

**لا حاجة لرفع يدوي!**

---

## 🐛 مشاكل شائعة

### "Failed to authenticate"
```bash
wrangler login
```

### "Module not found"
```bash
npm install
```

### "Durable Objects not found"
- تأكد من وجود `[[migrations]]` في `wrangler.toml`

---

## 📊 المراقبة

```bash
# Logs في الوقت الفعلي
wrangler tail

# Dashboard
# https://dash.cloudflare.com → Workers & Pages
```

---

**جاهز!** 🎉

