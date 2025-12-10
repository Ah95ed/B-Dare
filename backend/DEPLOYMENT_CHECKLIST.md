# ✅ Checklist للنشر على Cloudflare

## قبل النشر

### 1. الملفات المطلوبة

- [ ] `src/index.ts` موجود ويحتوي على الكود الصحيح
- [ ] `src/GameRoom.ts` موجود ويحتوي على Durable Object
- [ ] `src/TournamentRoom.ts` موجود ويحتوي على Durable Object
- [ ] `package.json` موجود ويحتوي على جميع dependencies
- [ ] `wrangler.toml` موجود ومُعد بشكل صحيح
- [ ] `tsconfig.json` موجود

### 2. الإعدادات في wrangler.toml

- [ ] `name` محدد (اسم المشروع)
- [ ] `main` محدد (مسار entry point)
- [ ] `compatibility_date` محدد
- [ ] Durable Objects bindings موجودة:
  - [ ] `GAME_ROOM` binding
  - [ ] `TOURNAMENT_ROOM` binding
- [ ] KV Namespaces (إذا لزم الأمر):
  - [ ] `GAME_STATE_KV` (اختياري)
  - [ ] `TOURNAMENT_KV` (اختياري)
- [ ] Migrations موجودة (إذا كان هناك Durable Objects)

### 3. Dependencies

- [ ] `npm install` تم بنجاح
- [ ] جميع dependencies مثبتة بدون أخطاء
- [ ] لا توجد warnings خطيرة

### 4. اختبار محلي

- [ ] `wrangler dev` يعمل بدون أخطاء
- [ ] يمكن إنشاء غرفة لعبة
- [ ] WebSocket connections تعمل
- [ ] REST API endpoints تعمل

---

## أثناء النشر

### 1. تسجيل الدخول

- [ ] `wrangler login` تم بنجاح
- [ ] `wrangler whoami` يعرض حسابك

### 2. النشر

- [ ] `wrangler deploy` يعمل بدون أخطاء
- [ ] تم الحصول على URL (مثل: `https://mystery-link-backend.xxx.workers.dev`)
- [ ] لا توجد أخطاء في console

---

## بعد النشر

### 1. التحقق من النشر

- [ ] Health check يعمل: `GET https://YOUR_URL/health`
- [ ] يمكن إنشاء غرفة: `POST https://YOUR_URL/api/create-room`
- [ ] WebSocket connection يعمل

### 2. تحديث Flutter App

- [ ] تحديث `lib/core/constants/app_constants.dart`:
  - [ ] `cloudflareWorkerUrl` محدث
  - [ ] `cloudflareWorkerHttpUrl` محدث
- [ ] اختبار الاتصال من Flutter app

### 3. المراقبة

- [ ] فتح Cloudflare Dashboard
- [ ] التحقق من Workers → mystery-link-backend
- [ ] مراقبة Logs (wrangler tail)
- [ ] التحقق من Metrics (requests, errors, etc.)

---

## استكشاف الأخطاء

### إذا فشل النشر:

- [ ] تحقق من `wrangler.toml` (syntax صحيح)
- [ ] تحقق من `package.json` (dependencies صحيحة)
- [ ] تحقق من TypeScript errors: `wrangler deploy --dry-run`
- [ ] تحقق من تسجيل الدخول: `wrangler whoami`

### إذا فشل الاتصال:

- [ ] تحقق من URL (صحيح ومحدث)
- [ ] تحقق من CORS headers
- [ ] تحقق من WebSocket URL (يجب أن يكون `wss://` وليس `ws://`)
- [ ] تحقق من Logs في Cloudflare Dashboard

---

## الملفات النهائية المرفوعة

بعد النشر الناجح، هذه هي الملفات التي تم رفعها:

```
✅ src/index.ts
✅ src/GameRoom.ts
✅ src/TournamentRoom.ts
✅ package.json
✅ wrangler.toml
✅ tsconfig.json
```

**ملاحظة:** `node_modules` و `dist` لا يُرفعان - يتم بناؤهما تلقائياً على Cloudflare.

---

## الخطوات التالية

1. ✅ احفظ URL الخاص بك
2. ✅ حدّث Flutter app
3. ✅ اختبر الاتصال
4. ✅ راقب Logs
5. ✅ اختبر مع لاعبين حقيقيين

---

**تاريخ آخر تحديث:** ديسمبر 2025

