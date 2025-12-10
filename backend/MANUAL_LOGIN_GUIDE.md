# دليل تسجيل الدخول اليدوي في Cloudflare

## المشكلة

Wrangler لا يستطيع فتح المتصفح تلقائياً في بعض البيئات.

## الحل: تسجيل الدخول يدوياً

### الطريقة 1: استخدام API Token (موصى به)

1. **اذهب إلى Cloudflare Dashboard:**
   - [https://dash.cloudflare.com/profile/api-tokens](https://dash.cloudflare.com/profile/api-tokens)

2. **أنشئ API Token:**
   - اضغط "Create Token"
   - اختر "Edit Cloudflare Workers" template
   - أو أنشئ token مخصص مع الصلاحيات التالية:
     - `Account:Cloudflare Workers:Edit`
     - `Account:Workers Scripts:Edit`
     - `Account:Workers KV Storage:Edit`
     - `Account:Workers Tail:Read`

3. **احفظ الـ Token** (سيظهر مرة واحدة فقط!)

4. **استخدم الـ Token:**
   ```bash
   wrangler login
   # عندما يسألك، اختر "Use API Token"
   # الصق الـ Token
   ```

### الطريقة 2: فتح الرابط يدوياً

1. **شغّل الأمر:**
   ```bash
   wrangler login
   ```

2. **انسخ الرابط** الذي يظهر (يبدأ بـ `https://dash.cloudflare.com/oauth2/auth...`)

3. **افتح الرابط** في المتصفح يدوياً

4. **سجّل الدخول** في Cloudflare

5. **سيتم إعادة التوجيه** تلقائياً

### الطريقة 3: استخدام Environment Variable

```bash
# Windows PowerShell
$env:CLOUDFLARE_API_TOKEN="your_token_here"

# ثم
wrangler deploy
```

---

## بعد تسجيل الدخول

بمجرد تسجيل الدخول بنجاح، يمكنك المتابعة:

```bash
wrangler deploy
```

---

## التحقق من تسجيل الدخول

```bash
wrangler whoami
```

إذا كان مسجل الدخول، سترى معلومات حسابك.


