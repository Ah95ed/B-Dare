# 🔐 دليل إعداد API Token في Cloudflare - ديسمبر 2025

**تاريخ التحديث:** 3 ديسمبر 2025  
**الغرض:** إعداد API Token للنشر على Cloudflare Workers مع Durable Objects

---

## 📋 نظرة عامة

API Token يسمح لـ Wrangler CLI بالتفاعل مع Cloudflare بدون الحاجة لتسجيل الدخول عبر المتصفح. هذه الطريقة **أكثر أماناً** و**أسهل** للاستخدام في CI/CD.

---

## 🎯 الصلاحيات المطلوبة لمشروع Mystery Link

بناءً على `wrangler.toml` والمشروع، نحتاج إلى الصلاحيات التالية:

### ✅ الصلاحيات الأساسية (إلزامية):

1. **Workers Scripts - Edit** ⭐⭐ **الأهم**
   - لنشر وتحديث Workers
   - **يشمل إدارة Durable Objects تلقائياً** (GameRoom و TournamentRoom)
   - لإنشاء وتحديث Durable Objects migrations

2. **Workers Tail - Read** ⭐
   - لمراقبة الـ logs في الوقت الفعلي
   - لاستكشاف الأخطاء

3. **Account Settings - Read** ⭐
   - لقراءة إعدادات الحساب
   - للتحقق من الـ limits والـ quotas

**ملاحظة مهمة:** Durable Objects **ليست صلاحية منفصلة** - يتم إدارتها تلقائياً من خلال **Workers Scripts - Edit**.

### ✅ الصلاحيات الاختيارية (للمستقبل):

5. **Workers KV Storage - Edit**
   - إذا أردت استخدام KV للـ persistence (حالياً معطل في wrangler.toml)

6. **Workers Routes - Edit**
   - إذا أردت ربط Worker بـ custom domain

7. **Workers R2 Storage - Edit**
   - إذا أردت استخدام R2 للـ file storage

---

## 🚀 خطوات الإعداد (خطوة بخطوة)

### **الخطوة 1: الوصول إلى صفحة API Tokens**

1. افتح المتصفح وانتقل إلى:
   ```
   https://dash.cloudflare.com/profile/api-tokens
   ```

2. أو من Dashboard:
   - انقر على **Profile** (أيقونة الشخص في الأعلى)
   - اختر **API Tokens** من القائمة الجانبية

---

### **الخطوة 2: إنشاء Token جديد**

1. انقر على **"Create Token"** (زر أزرق في الأعلى)

2. أو استخدم Template:
   - انقر على **"Get started"** بجانب **"Edit Cloudflare Workers"** template
   - هذا سيعطيك الصلاحيات الأساسية تلقائياً

---

### **الخطوة 3: ضبط Account Resources**

في قسم **"Account Resources"**:

1. **Include** (افتراضي) ✅
   - اتركه كما هو

2. **Select...** (Dropdown):
   - اختر حسابك (Account) من القائمة
   - إذا كان لديك حساب واحد فقط، سيظهر تلقائياً

**النتيجة:**
```
Account Resources
├── Include
└── Select... → [اسم حسابك]
```

---

### **الخطوة 4: ضبط Zone Resources (اختياري)**

في قسم **"Zone Resources"**:

**إذا كنت تريد ربط Worker بـ domain محدد:**

1. **Include** → **Specific zone**
2. **Select...** → اختر الـ domain

**إذا كنت تريد استخدام workers.dev subdomain فقط:**

1. يمكنك **تخطي** هذا القسم تماماً
2. أو اتركه **"Include"** → **"All zones"**

**النتيجة (للاستخدام البسيط):**
```
Zone Resources
├── Include
└── All zones (أو تخطي)
```

---

### **الخطوة 5: ضبط Permissions (الأهم!)**

في قسم **"Permissions"**، أضف الصلاحيات التالية:

#### **5.1 الصلاحيات الأساسية (إلزامية):**

انقر على **"+ Add more"** وأضف كل صف:

| Resource Scope | Resource Type | Permission Level |
|---------------|---------------|------------------|
| Account | **Workers Scripts** | **Edit** |
| Account | **Workers Tail** | **Read** |
| Account | **Account Settings** | **Read** |

**⚠️ ملاحظة:** Durable Objects **غير موجودة** كصلاحية منفصلة - يتم إدارتها تلقائياً من خلال **Workers Scripts - Edit**.

#### **5.2 الصلاحيات الاختيارية (للمستقبل):**

| Resource Scope | Resource Type | Permission Level |
|---------------|---------------|------------------|
| Account | Workers KV Storage | **Edit** |
| Account | Workers Routes | **Edit** |
| Account | Workers R2 Storage | **Edit** |

**النتيجة النهائية:**
```
Permissions:
├── Account - Workers Scripts - Edit ⭐ (يشمل Durable Objects)
├── Account - Workers Tail - Read
├── Account - Account Settings - Read
├── Account - Workers KV Storage - Edit (اختياري)
├── Account - Workers Routes - Edit (اختياري)
└── Account - Workers R2 Storage - Edit (اختياري)
```

---

### **الخطوة 6: Client IP Address Filtering (اختياري)**

في قسم **"Client IP Address Filtering"**:

**للاستخدام العادي:**
- ✅ اتركه فارغاً (سيطبق على جميع الـ IPs)

**للأمان الإضافي:**
- أضف IP addresses محددة إذا كنت تريد تقييد الوصول

---

### **الخطوة 7: TTL (Time To Live) - اختياري**

في قسم **"TTL"**:

**للاستخدام الدائم:**
- ✅ اتركه فارغاً (لا ينتهي)

**للأمان الإضافي:**
- حدد تاريخ انتهاء إذا كنت تريد تجديد Token دورياً

---

### **الخطوة 8: Review و Create**

1. انقر على **"Continue to summary"**

2. راجع الإعدادات:
   - ✅ Account Resources
   - ✅ Zone Resources
   - ✅ Permissions
   - ✅ TTL

3. انقر على **"Create Token"**

4. **⚠️ مهم جداً:** انسخ الـ Token فوراً!
   ```
   ستحصل على token مثل:
   abc123def456ghi789jkl012mno345pqr678stu901vwx234yz
   ```

5. **⚠️ تحذير:** لن تتمكن من رؤية Token مرة أخرى بعد إغلاق الصفحة!

---

## 🔧 استخدام Token في Wrangler

### **الطريقة 1: استخدام Token مباشرة**

```bash
wrangler login --api-token
```

ثم الصق الـ Token عند الطلب.

### **الطريقة 2: استخدام Environment Variable**

```bash
# Windows PowerShell
$env:CLOUDFLARE_API_TOKEN="your_token_here"
wrangler deploy

# Windows CMD
set CLOUDFLARE_API_TOKEN=your_token_here
wrangler deploy

# Linux/Mac
export CLOUDFLARE_API_TOKEN="your_token_here"
wrangler deploy
```

### **الطريقة 3: استخدام ملف .env (موصى به)**

1. أنشئ ملف `.env` في مجلد `backend/`:
   ```env
   CLOUDFLARE_API_TOKEN=your_token_here
   ```

2. Wrangler سيقرأه تلقائياً

**⚠️ مهم:** أضف `.env` إلى `.gitignore`!

---

## ✅ التحقق من Token

بعد إنشاء Token، اختبره:

```bash
# التحقق من الهوية
wrangler whoami

# النتيجة المتوقعة:
# ✅ You are logged in as: your-email@example.com
```

---

## 🎯 الإعدادات الموصى بها لمشروع Mystery Link

### **الإعدادات الدنيا (للبدء السريع):**

```
Account Resources:
├── Include
└── [اسم حسابك]

Zone Resources:
└── (تخطي - غير مطلوب)

Permissions:
├── Account - Workers Scripts - Edit ⭐ (يشمل Durable Objects)
├── Account - Workers Tail - Read
└── Account - Account Settings - Read

Client IP Filtering:
└── (فارغ - جميع IPs)

TTL:
└── (فارغ - لا ينتهي)
```

### **الإعدادات الكاملة (للاستخدام المستقبلي):**

```
Account Resources:
├── Include
└── [اسم حسابك]

Zone Resources:
├── Include
└── All zones (أو domain محدد)

Permissions:
├── Account - Workers Scripts - Edit ⭐ (يشمل Durable Objects)
├── Account - Workers Tail - Read
├── Account - Account Settings - Read
├── Account - Workers KV Storage - Edit
├── Account - Workers Routes - Edit
└── Account - Workers R2 Storage - Edit

Client IP Filtering:
└── (فارغ - جميع IPs)

TTL:
└── (فارغ - لا ينتهي)
```

---

## 🐛 استكشاف الأخطاء

### **المشكلة: "Invalid API Token"**

**الحل:**
- ✅ تأكد من نسخ Token بالكامل (بدون مسافات)
- ✅ تأكد من أن Token لم ينتهِ (إذا حددت TTL)
- ✅ أنشئ Token جديد

### **المشكلة: "Insufficient permissions"**

**الحل:**
- ✅ تأكد من إضافة جميع الصلاحيات المطلوبة:
  - Workers Scripts - Edit (يشمل Durable Objects تلقائياً)
  - Workers Tail - Read
  - Account Settings - Read

### **المشكلة: "Token not found"**

**الحل:**
- ✅ تأكد من استخدام `--api-token` flag
- ✅ أو ضع Token في environment variable
- ✅ أو ضع Token في ملف `.env`

---

## 🔒 الأمان

### **أفضل الممارسات:**

1. ✅ **لا تشارك Token** مع أي شخص
2. ✅ **لا ترفع Token** إلى Git (استخدم `.gitignore`)
3. ✅ **استخدم TTL** إذا أمكن (لتجديد دوري)
4. ✅ **استخدم IP Filtering** إذا كان لديك IP ثابت
5. ✅ **احذف Token** إذا لم تعد بحاجة إليه

### **إذا تم تسريب Token:**

1. ✅ اذهب إلى [API Tokens](https://dash.cloudflare.com/profile/api-tokens)
2. ✅ ابحث عن Token المسرب
3. ✅ انقر على **"Revoke"** (إلغاء)
4. ✅ أنشئ Token جديد

---

## 📝 Checklist

### قبل إنشاء Token:
- [ ] لديك حساب Cloudflare نشط
- [ ] تعرف اسم Account الخاص بك
- [ ] قررت الصلاحيات المطلوبة

### أثناء إنشاء Token:
- [ ] ضبطت Account Resources
- [ ] أضفت جميع الصلاحيات المطلوبة
- [ ] راجعت الإعدادات
- [ ] نسخت Token فوراً

### بعد إنشاء Token:
- [ ] اختبرت Token بـ `wrangler whoami`
- [ ] حفظت Token في مكان آمن
- [ ] أضفت `.env` إلى `.gitignore`
- [ ] جربت النشر بـ `wrangler deploy`

---

## 🎉 الخلاصة

### الإعدادات الموصى بها للبدء:

1. **Account Resources:** Include → [اسم حسابك]
2. **Zone Resources:** تخطي (أو All zones)
3. **Permissions:**
   - **Workers Scripts - Edit** ⭐ (يشمل Durable Objects تلقائياً)
   - Workers Tail - Read
   - Account Settings - Read
4. **Client IP Filtering:** فارغ
5. **TTL:** فارغ

### بعد إنشاء Token:

```bash
# استخدام Token
wrangler login --api-token
# الصق Token

# أو
export CLOUDFLARE_API_TOKEN="your_token"
wrangler deploy
```

---

**تاريخ التحديث:** 3 ديسمبر 2025  
**الحالة:** ✅ جاهز للاستخدام

