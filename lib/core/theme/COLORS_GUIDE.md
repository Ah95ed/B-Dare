# دليل نظام الألوان - Mystery Link

## نظرة عامة

تم تنظيم نظام الألوان في `colors.dart` بشكل هرمي ومنطقي لتسهيل الاستخدام والصيانة.

## هيكل الألوان

### 1. ألوان العلامة التجارية (Brand Colors)

#### Primary (أساسي)
- `primary`: `#6366F1` - اللون الأساسي للتطبيق (Indigo)
- `primaryDark`: `#4F46E5` - نسخة داكنة
- `primaryLight`: `#818CF8` - نسخة فاتحة

**الاستخدام**: أزرار رئيسية، عناصر تفاعلية، وضع Solo Mode

#### Secondary (ثانوي)
- `secondary`: `#10B981` - أخضر
- `secondaryDark`: `#059669`
- `secondaryLight`: `#34D399`

**الاستخدام**: وضع Group Mode، عناصر نجاح، إجابات صحيحة

#### Accent (مميز)
- `accent`: `#F59E0B` - برتقالي/ذهبي
- `accentDark`: `#D97706`

**الاستخدام**: وضع Practice Mode، تحذيرات، عناصر مميزة

### 2. ألوان الحالة (Status Colors)

- `success`: `#10B981` - نجاح / إجابة صحيحة
- `error`: `#EF4444` - خطأ / إجابة خاطئة
- `warning`: `#F59E0B` - تحذير / وقت منخفض
- `info`: `#3B82F6` - معلومات / إرشادات

### 3. ألوان محايدة (Neutral Colors)

#### الخلفيات
- `background`: `#F9FAFB` - خلفية الوضع الفاتح
- `backgroundDark`: `#111827` - خلفية الوضع الداكن
- `surface`: `#FFFFFF` - سطح الوضع الفاتح (بطاقات)
- `surfaceDark`: `#1F2937` - سطح الوضع الداكن

#### النصوص
- `textPrimary`: `#111827` - نص رئيسي (وضع فاتح)
- `textSecondary`: `#6B7280` - نص ثانوي / باهت
- `textDark`: `#F9FAFB` - نص رئيسي (وضع داكن)

### 4. ألوان خاصة باللعبة (Game Colors)

- `cardStart`: `#8B5CF6` - لون بطاقة البداية (A) - بنفسجي
- `cardEnd`: `#EC4899` - لون بطاقة النهاية (Z) - وردي
- `cardLink`: `#6366F1` - لون الروابط الوسيطة المختارة

### 5. ألوان أنماط اللعب (Game Mode Colors)

- `modeSolo`: نفس `primary` - وضع Solo
- `modeGroup`: نفس `secondary` - وضع Group
- `modePractice`: نفس `accent` - وضع Practice
- `modeGuided`: نفس `info` - الوضع الموجّه
- `modeDaily`: `#8B5CF6` - التحدي اليومي

## طرق مساعدة (Helper Methods)

### `getAnswerColor(bool isCorrect)`
يعيد لون حسب صحة الإجابة:
- `true` → `success` (أخضر)
- `false` → `error` (أحمر)

### `getTimeColor(int remainingSeconds, int totalSeconds)`
يعيد لون حسب نسبة الوقت المتبقي:
- أقل من 20% → `error` (أحمر)
- أقل من 50% → `warning` (برتقالي)
- أكثر من 50% → `primary` (أزرق)

### `getModeColor(String gameMode)`
يعيد لون حسب نمط اللعب:
- `'solo'` → `modeSolo`
- `'group'` → `modeGroup`
- `'practice'` → `modePractice`
- `'guided'` → `modeGuided`
- `'daily'` → `modeDaily`

## أفضل الممارسات

1. **استخدم الألوان المحددة مسبقاً**: لا تعرّف ألوان جديدة إلا عند الضرورة
2. **استخدم Helper Methods**: استخدم `getAnswerColor()` و `getTimeColor()` بدلاً من الشروط اليدوية
3. **احترم الوضع الفاتح/الداكن**: استخدم `textPrimary`/`textDark` حسب الوضع
4. **استخدم Opacity للتدرجات**: استخدم `.withOpacity()` لإنشاء تدرجات لونية
5. **اتساق الألوان**: استخدم نفس الألوان لنفس الغرض في كل التطبيق

## أمثلة الاستخدام

```dart
// إجابة صحيحة
Container(
  color: AppColors.getAnswerColor(true), // أخضر
)

// وقت منخفض
TimerWidget(
  remainingSeconds: 5,
  totalSeconds: 30,
  // يستخدم getTimeColor داخلياً
)

// نمط اللعب
ModeCard(
  color: AppColors.getModeColor('solo'), // أزرق
)
```

