دليل النشر السريع لـ `mystery-link-backend`

هذا الملف يشرح الخطوات اللازمة لتهيئة ونشر الـ Cloudflare Worker الموجود في `my-backend/`، وتشغيل عميل اختبار WebSocket.

المتطلبات:
- Node.js و npm
- حساب Cloudflare
- wrangler (يمكن استخدام النسخة المحلية عبر npx)

خطوات سريعة (PowerShell):

1) تثبيت الاعتماديات
```powershell
cd 'C:\Users\msi\Downloads\mysterylink\my-backend'
npm install
```

2) تسجيل الدخول إلى Cloudflare عبر wrangler
```powershell
# هذا يفتح متصفحًا للمصادقة
npx wrangler login
```

3) تكوين `wrangler.toml`
- افتح `my-backend/wrangler.toml` وضع `account_id` الخاص بحساب Cloudflare.
- في `[env.production.vars]` ضع `ALLOWED_ORIGINS` بدومين لعبتك (مثال: `https://mygame.example.com`).

4) ضبط المتغيرات السرية
```powershell
# ضع قيمة آمنة لـ JWT_SECRET
npx wrangler secret put JWT_SECRET --env production
```

5) (اختياري) إنشاء KV namespaces
```powershell
npx wrangler kv:namespace create "GAME_STATE_KV"
# إنشاؤه سيطبع ID استخدمه في wrangler.toml ضمن [[kv_namespaces]]
```

6) تجربة نشر جافة ثم نشر حقيقي
```powershell
# جاف (لا ينشر فعليًا)
npx wrangler deploy --dry-run

# نشر فعلي
npx wrangler deploy
# أو للبيئة الإنتاجية
npx wrangler deploy --env production
```

7) اختبار نقاط النهاية (مثال PowerShell)
```powershell
# استبدل بالـ URL بعد النشر
Invoke-RestMethod -Uri 'https://my-backend.amhmeed31.workers.dev/health'
Invoke-RestMethod -Method Post -Uri 'https://my-backend.amhmeed31.workers.dev/api/create-room'
```

8) مشاهدة السجلات
```powershell
npx wrangler tail
```

روبوت اختبار ويب (تجريبي)
- يوجد ملف `test-client.html` بسيط داخل نفس المجلد يمكنك فتحه في المتصفح (او عبر server محلي) لاختبار إنشاء غرفة والاتصال بالـ WebSocket.

ملاحظات أمنية
- لا تضع `JWT_SECRET` أو API tokens في المستودع.
- في الإنتاج ضع `ALLOWED_ORIGINS` بدومين لعبتك بدل `*`.

إذا تريد، أستطيع:
- تحديث `wrangler.toml` بالإعدادات النهائية إن أعطيتني `account_id` و`zone_id` (لا ترسل أسرارك هنا)،
- أو تنفيذ نشر تجريبي داخل بيئتك إذا تُنفِّذ الأوامر أعلاه ثم تعطيني نتائج `wrangler deploy --dry-run` لمراجعتها.
