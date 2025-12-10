# Puzzle Generation Pipeline

هذه الوثيقة توضح كيفية تجهيز 30 مرحلة (Level) لكل نمط لعب، وكل مرحلة تحتوي على 10 تحديات (Challenges)، مع ربطها بالبنية الحالية للتطبيق.

## 1. تعريف الحقول في نموذج اللغز

تم تحديث `Puzzle` و `PuzzleModel` لتتضمن الحقول التالية:

- `level`: رقم المرحلة (1-30).
- `challengeNumber`: ترتيب التحدي داخل المرحلة (1-10).
- `targetSkill`: المهارة المستهدفة (مثل memory، association).
- `tags`: قائمة وسوم للمحتوى أو الموضوع.
- `theme`: الثيمة العامة للمستوى.
- `progressionData`: بيانات تقدم إضافية (`rewardXp`, `season`, …).

تأكد من أن أي سجل جديد في `assets/data/puzzles.json` يحتوي على هذه الحقول ليتمكن المستودع من تصفية الألغاز حسب المستوى والنمط.

## 2. سكربت التوليد

يوجد سكربت في `tool/generators/puzzle_batch_generator.dart`:

```bash
dart run tool/generators/puzzle_batch_generator.dart --output build/generated_puzzles.json
```

السكربت يقوم بإنشاء 30 مستوى × 10 تحديات لكل نمط معرف في الخريطة الداخلية. يتم إنتاج ملف JSON يمكن دمجه مع `assets/data/puzzles.json` بعد المراجعة أو بإدخاله إلى KV/Backend.

## 3. دمج مستويات اللعب

بعد تشغيل السكربت:

1. افتح الملف الناتج وادمج أو استبدل البيانات في `assets/data/puzzles.json`.
2. شغّل `flutter pub run build_runner build` إذا كنت تستخدم توليد كود يعتمد على الملف.
3. اختبر التحميل عبر `PuzzleRepository.getPuzzlesForLevel` و`getPuzzleForChallenge`.

## 4. استخدام بيانات المستويات

تمت إضافة واجهات جديدة في `PuzzleRepositoryInterface`:

- `getPuzzlesForLevel(GameType mode, int level)`
- `getPuzzleForChallenge(GameType mode, int level, int challengeNumber)`
- `getLevelsForMode(GameType mode, {int? maxLevels})`

يمكن استخدام هذه الطرق في واجهات المستخدم لإظهار التقدم، أو في backend للتحقق من المستوى المحدد قبل بدء تحدّي جديد.

**شاشة المستويات الجديدة**  
تمت إضافة شاشة `LevelSelectionScreen` يمكن الوصول إليها عبر المسار `AppConstants.routeLevelSelection`. من الصفحة الرئيسية يوجد زر *Levels & Challenges* يفتح هذه الشاشة ويعرض 30 مستوى لكل نمط (مع 10 تحديات لكل مستوى).

## 5. خطوات مستقبلية

- الربط مع Cloudflare KV لضمان أن نفس مستويات التحديات متاحة في اللعب الجماعي.
- إضافة Analytics لتتبع تقدم المستخدم لكل مستوى.
- كتابة اختبارات وحدات للتأكد من أن كل نمط يحتوي على 300 تحدٍ (30 × 10).
