# ⚡ إعداد API Token السريع - Cloudflare

**تاريخ التحديث:** 3 ديسمبر 2025

---

## 🎯 الإعدادات السريعة الموصى بها

### **1. Account Resources:**
```
Include → [اسم حسابك]
```

### **2. Zone Resources:**
```
(تخطي - غير مطلوب للبدء)
```

### **3. Permissions (3 صلاحيات أساسية):**

انقر **"+ Add more"** وأضف:

| Resource Scope | Resource Type | Permission |
|---------------|---------------|------------|
| Account | **Workers Scripts** | **Edit** ⭐ (يشمل Durable Objects) |
| Account | **Workers Tail** | **Read** |
| Account | **Account Settings** | **Read** |

**⚠️ ملاحظة:** Durable Objects **غير موجودة** كصلاحية منفصلة - يتم إدارتها تلقائياً من خلال **Workers Scripts - Edit**.

### **4. Client IP Filtering:**
```
(فارغ - اتركه كما هو)
```

### **5. TTL:**
```
(فارغ - لا ينتهي)
```

---

## ✅ بعد إنشاء Token

### **الطريقة 1: مباشرة**
```bash
wrangler login --api-token
# الصق Token عند الطلب
```

### **الطريقة 2: Environment Variable**
```bash
# Windows PowerShell
$env:CLOUDFLARE_API_TOKEN="your_token_here"

# ثم
wrangler deploy
```

### **الطريقة 3: ملف .env**
أنشئ `backend/.env`:
```env
CLOUDFLARE_API_TOKEN=your_token_here
```

**⚠️ مهم:** أضف `.env` إلى `.gitignore`!

---

## 🔍 التحقق

```bash
wrangler whoami
```

**النتيجة المتوقعة:**
```
✅ You are logged in as: your-email@example.com
```

---

## 📚 الدليل الكامل

راجع `docs/CLOUDFLARE_API_TOKEN_SETUP.md` للتفاصيل الكاملة.

---

**جاهز!** 🚀

