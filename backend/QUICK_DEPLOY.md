# 🚀 نشر سريع على Cloudflare

## الخطوات (بعد تسجيل الدخول)

### 1. تأكد من تسجيل الدخول:

```bash
wrangler whoami
```

إذا لم تكن مسجل الدخول، اتبع `MANUAL_LOGIN_GUIDE.md`

### 2. النشر:

```bash
wrangler deploy
```

### 3. احفظ الـ URL:

بعد النشر، ستحصل على URL مثل:
```
https://mystery-link-backend.YOUR_SUBDOMAIN.workers.dev
```

### 4. حدّث Flutter:

في `lib/core/constants/app_constants.dart`:

```dart
static const String cloudflareWorkerUrl = 'wss://YOUR_ACTUAL_URL.workers.dev';
static const String cloudflareWorkerHttpUrl = 'https://YOUR_ACTUAL_URL.workers.dev';
```

---

## إذا واجهت مشاكل

راجع `MANUAL_LOGIN_GUIDE.md` لتسجيل الدخول يدوياً.


