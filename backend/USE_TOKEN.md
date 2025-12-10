# 🔐 استخدام API Token - خطوات سريعة

## الطريقة 1: استخدام Environment Variable (موصى به)

### في PowerShell:

```powershell
# 1. ضع Token في environment variable
$env:CLOUDFLARE_API_TOKEN="your_token_here"

# 2. تحقق من تسجيل الدخول
wrangler whoami

# 3. انشر المشروع
wrangler deploy
```

### في CMD:

```cmd
set CLOUDFLARE_API_TOKEN=your_token_here
wrangler whoami
wrangler deploy
```

---

## الطريقة 2: استخدام ملف .env

### 1. أنشئ ملف `.env` في مجلد `backend/`:

```env
CLOUDFLARE_API_TOKEN=your_token_here
```

### 2. تأكد من إضافة `.env` إلى `.gitignore`:

```
backend/.env
```

### 3. استخدم Wrangler:

```bash
wrangler whoami
wrangler deploy
```

---

## ⚠️ ملاحظات مهمة:

1. **لا تشارك Token** مع أي شخص
2. **لا ترفع `.env`** إلى Git
3. **انسخ Token** من Cloudflare Dashboard

---

## ✅ بعد إعداد Token:

1. ✅ `wrangler whoami` - للتحقق
2. ✅ `wrangler deploy` - للنشر
3. ✅ احفظ URL الناتج

