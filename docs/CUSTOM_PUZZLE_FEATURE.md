# ميزة الألغاز المخصصة: Custom Puzzles

## نظرة عامة

تم إضافة ميزة تسمح لمنشئ المجموعة بإنشاء ألغاز مخصصة يدوياً بدلاً من الاعتماد على الألغاز التلقائية من التطبيق.

---

## الميزات

### 1. وضع اللغز (Puzzle Mode)

#### الوضع التلقائي (Auto):
- التطبيق يختار اللغز تلقائياً من قاعدة البيانات
- يمكن اختيار الفئة والصعوبة
- مناسب للعب السريع

#### الوضع اليدوي (Manual):
- منشئ المجموعة ينشئ اللغز كاملاً
- يحدد Start Node و End Node
- يضيف الخطوات مع الخيارات
- يحدد الإجابة الصحيحة لكل خطوة
- التطبيق يعرض اللغز للاعبين ويكتشف الإجابات الصحيحة

---

## كيفية الاستخدام

### إنشاء لغز مخصص:

1. **في شاشة "Create Group"**:
   - اختر "Puzzle Mode"
   - اختر "Manual" بدلاً من "Auto"
   - اضغط "Create Custom Puzzle"

2. **في شاشة "Create Custom Puzzle"**:
   - أدخل **Start Node** (مثلاً: "Apple")
   - أدخل **End Node** (مثلاً: "Tree")
   - حدد **Time Limit** لكل خطوة
   - أضف **Steps**:
     - اضغط "Add Step" لإضافة خطوة جديدة
     - لكل خطوة، أضف خيارات متعددة
     - حدد الإجابة الصحيحة بعلامة ✓
     - يمكن إضافة/حذف خيارات

3. **بعد الإنشاء**:
   - سيظهر معاينة للغز المخصص
   - يمكن التعديل بالضغط على "Edit"
   - اضغط "Start Group Game" لبدء اللعبة

---

## الواجهة

### شاشة Create Custom Puzzle:

```
┌─────────────────────────────┐
│  Create Custom Puzzle       │
├─────────────────────────────┤
│  [Info Banner]              │
│                             │
│  Start Node                 │
│  [Apple____________]        │
│                             │
│  End Node                   │
│  [Tree_____________]        │
│                             │
│  Time Limit                 │
│  [━━━━━━━━━━━━━━━━━━━━]     │
│  12 seconds                 │
│                             │
│  Steps (2)        [+ Add]   │
│                             │
│  ┌─ Step 1 ──────────────┐ │
│  │ Option 1 [✓] [Delete] │ │
│  │ Option 2 [ ] [Delete] │ │
│  │ [+ Add Option]        │ │
│  └────────────────────────┘ │
│                             │
│  [Create Puzzle]            │
└─────────────────────────────┘
```

---

## الملفات المُنشأة

### 1. `lib/features/group/domain/entities/custom_puzzle.dart`
- **الوظيفة**: نموذج بيانات للغز المخصص
- **الميزات**:
  - تحويل إلى Puzzle عادي
  - Serialization/Deserialization
  - حساب الصعوبة تلقائياً

### 2. `lib/features/group/presentation/screens/create_custom_puzzle_screen.dart`
- **الوظيفة**: شاشة إنشاء اللغز المخصص
- **الميزات**:
  - واجهة سهلة لإنشاء الألغاز
  - إضافة/حذف الخطوات
  - إضافة/حذف الخيارات
  - تحديد الإجابة الصحيحة
  - التحقق من صحة البيانات

---

## الملفات المُحدّثة

### 1. `lib/features/group/presentation/screens/create_group_screen.dart`
- إضافة خيار "Puzzle Mode"
- دعم الألغاز المخصصة
- معاينة اللغز المخصص

### 2. `lib/features/game/presentation/bloc/game_event.dart`
- إضافة `customPuzzle` إلى `GameStarted`

### 3. `lib/features/game/presentation/bloc/game_bloc.dart`
- دعم تحميل الألغاز المخصصة
- تحويل CustomPuzzle إلى Puzzle

### 4. `lib/features/game/presentation/screens/game_screen.dart`
- تمرير `customPuzzle` إلى GameBloc

### 5. `lib/core/router/app_router.dart`
- دعم `customPuzzle` في arguments

---

## الميزات التقنية

### CustomPuzzle Entity:
```dart
class CustomPuzzle {
  final String id;
  final String creatorId;
  final LinkNode start;
  final LinkNode end;
  final List<PuzzleStep> steps;
  final RepresentationType type;
  final int timeLimit;
  
  Puzzle toPuzzle(); // Convert to standard Puzzle
}
```

### التحويل:
- `CustomPuzzle` → `Puzzle` تلقائياً
- يحافظ على جميع البيانات
- يدعم جميع أنواع العرض

---

## التحقق من الصحة

### قبل إنشاء اللغز:
- ✅ Start Node غير فارغ
- ✅ End Node غير فارغ
- ✅ على الأقل خطوة واحدة
- ✅ كل خطوة لها خيار واحد على الأقل
- ✅ كل خطوة لها إجابة صحيحة واحدة على الأقل

---

## أمثلة الاستخدام

### مثال 1: لغز بسيط
- **Start**: Apple
- **End**: Tree
- **Steps**: 1
  - Option 1: Seed (✓)
  - Option 2: Water
  - Option 3: Sun

### مثال 2: لغز معقد
- **Start**: Water
- **End**: Electricity
- **Steps**: 3
  - Step 1: Dam → Turbine → Generator
  - Step 2: ...
  - Step 3: ...

---

## الميزات المستقبلية

### قيد التطوير:
- [ ] حفظ قوالب الألغاز
- [ ] مشاركة الألغاز المخصصة
- [ ] تصنيف الألغاز المخصصة
- [ ] تصويت على الألغاز
- [ ] مكتبة ألغاز مخصصة

---

## ملاحظات

### للمنشئين:
- تأكد من أن الألغاز منطقية
- استخدم خيارات واضحة
- حدد الإجابة الصحيحة بدقة

### للاعبين:
- الألغاز المخصصة تعمل مثل الألغاز العادية
- التطبيق يكتشف الإجابات الصحيحة تلقائياً
- النقاط تُحسب بنفس الطريقة

---

## استكشاف الأخطاء

### المشكلة: لا يمكن إنشاء اللغز
**الحل**: تأكد من:
- إدخال Start و End Nodes
- إضافة على الأقل خطوة واحدة
- تحديد إجابة صحيحة لكل خطوة

### المشكلة: اللغز لا يظهر في اللعبة
**الحل**: تأكد من:
- حفظ اللغز قبل بدء اللعبة
- اختيار "Manual" mode
- التحقق من صحة البيانات

---

**تاريخ الإضافة**: 2025
**الحالة**: ✅ جاهز للاستخدام

