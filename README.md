# Mystery Link Game

A Flutter game that challenges players to connect two elements (A → Z) through a chain of intermediate links (1-10 links).

## Features

- **Solo Mode**: Play alone and challenge yourself
- **Group Mode**: Play with friends (2-6 players) in local pass & play mode
- **Practice Mode**: Learn and practice with easy puzzles
- **Guided Mode**: Get hints and guidance while playing
- **Daily Challenges**: New puzzle every day
- **Multiple Representation Types**: Text, Icon, Image, and Event
- **Difficulty Levels**: 1-10 links per puzzle
- **30+ Puzzles**: Diverse puzzles across multiple categories
- **Scoring System**: Points based on correctness, difficulty, and speed
- **Progression System**: Level up, earn XP, unlock achievements
- **Bilingual Support**: Arabic and English with full RTL support
- **Beautiful UI**: Modern Material Design 3 with smooth animations
- **Splash Screen**: Elegant app launch experience

## Project Structure

```
lib/
  main.dart
  core/
    constants/      # App and game constants
    router/         # Navigation routing
    theme/          # App theme and colors
    utils/          # Utility functions and extensions
  features/
    home/           # Home screen
    mode_selection/ # Mode selection screen
    game/           # Game logic and UI
      data/         # Data models, repositories, datasources
      domain/       # Business logic entities
      presentation/ # UI (screens, widgets, BLoC)
    result/         # Result screen
  shared/
    widgets/        # Shared widgets
```

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate JSON serialization code (if needed):
   ```bash
   flutter pub run build_runner build
   ```

4. Run the app:
   ```bash
   flutter run
   ```

### Validating Puzzle Coverage

Before shipping new content, validate that every theme has puzzles for all four representation types (rules defined in `tool/puzzle_requirements.json`):

```bash
dart run tool/puzzle_validator.dart
```

The report highlights missing categories, representation gaps, and image-less puzzles.

## Architecture

The project follows **Clean Architecture** principles:

- **Data Layer**: Models, repositories, and datasources
- **Domain Layer**: Business logic entities and repository interfaces
- **Presentation Layer**: UI components, BLoC for state management

### State Management

The app uses **BLoC (Business Logic Component)** pattern for state management:
- `GameBloc`: Manages game state for solo mode
- `GroupGameBloc`: Manages game state for group mode

## Game Mechanics

1. **Puzzle Selection**: Choose representation type and difficulty (1-10 links)
2. **Gameplay**: Select the correct intermediate link at each step
3. **Scoring**: 
   - Base points per step: 100
   - Multiplier based on difficulty (links count)
   - Time bonus for quick answers
4. **Time Limit**: Configurable per puzzle (default: 12 seconds per step)

## Data

Puzzles are stored in `assets/data/puzzles.json` with the following structure:
- **30 puzzles** covering various categories:
  - General Knowledge
  - Science & Technology
  - Nature & Environment
  - History & Culture
  - Mathematics
  - Biology & Life Sciences
  - Geography & Earth Sciences
  - Physics, Chemistry, Astronomy
  - Technology & Computing
  - Medicine & Health
  - And more...
- Each puzzle has a start node (A) and end node (Z)
- Multiple steps with options (one correct, multiple distractors)
- Support for multiple languages and representation types
- Difficulty ranges from 1 to 10 links

## Testing

See [docs/TESTING_GUIDE.md](docs/TESTING_GUIDE.md) for comprehensive testing guidelines.

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
**نظرة عامة**
- **اسم المشروع:**: `Mystery Link` — لعبة أحجية تربط عنصرين عبر سلسلة من الروابط الوسيطة.
- **هدف الوثيقة:**: هذا `README.md` يقدّم تحليلاً تفصيليًا لكود المشروع، آليات اللعب، البنية الداخلية، وكيفية تشغيل وتوسيع اللعبة.

**ملخص اللعبة**
- **الفكرة الأساسية:**: اللاعب يبدأ بعنصر بداية (`start`) وعنصر نهاية (`end`) ويجب عليه اختيار سلسلة من الروابط (خطوات) تؤدي من البداية إلى النهاية عبر عدد محدد من الروابط (`linksCount`). كل خطوة تعرض خيارات؛ اختر الخيار الصحيح لتتقدم.
- **أنماط اللعبة:**: النمط الافتراضي هو `Mystery Link`، لكن الكود يدعم أنماطًا متعددة مثل: `Memory Flip`, `Spot the Odd`, `Sort & Solve`, `Story Tiles`, `Shadow Match`, `Emoji Circuit`, `Cipher Tiles`, `Spot the Change`, `Color Harmony`, `Puzzle Sentence`.
- **عناصر اللعبة:**: كل لغز (`Puzzle`) يحتوي على: `start`, `end`, عدد الروابط (`linksCount`), قائمة `steps` مع خيارات لكل خطوة، وحد زمني إجمالي (`timeLimit`).

**آليات اللعب الأساسية**
- **الخطوات والترتيب:**: اللعبة تعمل خطوة بخطوة (turn-based). لكل خطوة مجموعة من `StepOption` تحتوي `LinkNode` ووسم `isCorrect`.
- **الزمن والنقاط:**: لكل لغز زمن إجمالي (`timeLimit`). يوجد مكافآت زمنية إذا كانت الإجابة سريعة، وعقوبات عند استخدام تلميحات أو إجابات خاطئة. حساب النقاط يتم عبر `GameConstants` و`GameEngine` المناسب.
- **المساعدة والتدرج:**: هناك وضع `guided` يدعم تلميحات (hints) ويخفّض نقاط الخطوة عند استخدامها.
- **إنهاء اللعبة:**: تنتهي اللعبة عند استكمال عدد الروابط أو نفاد الوقت؛ تُسجّل نتيجة اللاعب عبر `ProgressionService` وواجهة التعلم التكيّفي (`AdaptiveLearningRepository`).

**بنية المشروع (مستوى عالٍ)**
- **الطبقات الرئيسية:**
  - **العرض (presentation):**: واجهات الشاشة، وواجهات المستخدم، وBLoC للحركة. المسار: `lib/features/game/presentation`.
  - **النطاق/الدومين (domain):**: الكيانات (entities) مثل `Puzzle`, `PuzzleStep`, `LinkNode`, واجهات المستودعات، ومحركات اللعبة (Game Engines). المسار: `lib/features/game/domain`.
  - **البيانات (data):**: مصادر البيانات ونماذج JSON والمستودعات. المسار: `lib/features/game/data`.
  - **الموارد العامة:**: إعدادات التطبيق والثيمات والراوتر والتوطين في `lib/core` و`lib/l10n`.

**مكونات أساسية (أسماء وملف موقعها)**
- **دخول التطبيق:**: `lib/main.dart` — يهيئ `RepositoryProvider` و`BlocProvider` ويشغّل التطبيق.
- **BLoC اللعبة:**: `lib/features/game/presentation/bloc/game_bloc.dart` — منطق الحالة، التعامل مع أحداث اللعبة (`StepOptionSelected`, `TimerTicked`, إلخ.).
- **نموذج اللغز:**: `lib/features/game/data/models/puzzle_model.dart` وملف `puzzle_step_model.dart` — يعرّف كيف تُحمّل وتنُسق بيانات الألغاز من `JSON`.
- **مصدر الألغاز محليًا:**: `lib/features/game/data/datasources/local_puzzle_datasource.dart` — يحمّل `assets/data/puzzles.json` ويفحص صحة البيانات.
- **مستودع الألغاز:**: `lib/features/game/data/repositories/puzzle_repository.dart` — caching، فلترة، اختيار عشوائي، وواجهات بحث.
- **محركات اللعبة:**: `lib/features/game/domain/services/engines/*` و`game_engine_factory.dart` — كل نمط له `GameEngine` منفصل (تنفيذ القواعد، التحقق من الحركات وحساب النقاط).
- **كيانات النطاق:**: `lib/features/game/domain/entities/` — `puzzle.dart`, `link_node.dart`, `puzzle_step.dart`, `game_type.dart`.

**تنسيق ملفات الألغاز (JSON)**
- **الموقع المتوقع:**: `assets/data/puzzles.json`.
- **مخطط موجز:** كل مدخل يتضمن الحقول الأساسية التالية:
  - `id`: معرف السجل.
  - `gameType`: اسم النمط (مثل `mysteryLink`).
  - `type`: تمثيل العقدة (`text`, `image`, `icon`, `event`).
  - `start`, `end`: كائنات `LinkNode` (حقل `id`, `label`, `representationType`, `imagePath` أو `iconName`, و`labels` للدولية).
  - `linksCount`: عدد الروابط المتوقعة.
  - `timeLimit`: زمن اللغز بالثواني.
  - `steps`: مصفوفة من الخطوات؛ كل خطوة لها `order` و`options` التي تحتوي `node` و`isCorrect`.

**التوطين (i18n)**
- المشروع يستخدم حزمة `flutter_localizations` وملفات `.arb` في `lib/l10n/` (مثال: `app_ar.arb`, `app_en.arb`). تسميات العقد (`LinkNode.labels`) تستعمل للنصوص المحلية داخل بيانات الألغاز.

**التبعيات المهمة**
- **حزمة الحالة:**: `flutter_bloc`, `equatable`.
- **التخزين:**: `shared_preferences`.
- **التوطين:**: `intl`.
- **وسائط / واجهة المستخدم:**: `lottie`, `google_fonts`.
- **تعدد اللاعبين / شبكات:**: `web_socket_channel`, `http` (مؤشرات لوجود دعم للـ multiplayer عبر WebSocket أو API).
- **أدوات التطوير:**: `build_runner`, `json_serializable`.

**كيفية التشغيل محليًا**
- **المتطلبات:**: Flutter SDK (مشغّل لـ `sdk: '>=3.0.0 <4.0.0'`).
- **الأوامر الأساسية:**
  - للحصول على الحزم:

```powershell
flutter pub get
```

  - لتشغيل التطبيق على جهاز متصل أو محاكي:

```powershell
flutter run
```

  - لتشغيل الاختبارات (إن وُجدت):

```powershell
flutter test
```

**إرشادات لإضافة لغز جديد**
- أضف مدخلاً جديدًا إلى `assets/data/puzzles.json` وفق نموذج `PuzzleModel`.
- تأكد من ضبط `gameType`, `linksCount`, و`steps` مع `isCorrect` واحد على الأقل لكل خطوة.
- شغّل `flutter pub get` ثم شغّل التطبيق وتحقق من ظهور اللغز في اختيار المستويات أو الوضع العشوائي.

**كيفية إضافة نمط لعبة جديد (Engine)**
- 1) أنشئ `GameEngine` جديد في `lib/features/game/domain/services/engines/` عبر تنفيذ `GameEngine`.
- 2) أضف استيرادًا للمحرك إلى `game_engine_factory.dart` وأضف حالة في `_createEngine` لإرجاع المحرك.
- 3) إن لزم، حدّث `Puzzle` و`PuzzleModel` لإضافة حقول خاصة بالنمط (`gameTypeData`).

**ملاحظات عن التقدّم والبيانات**
- السجلات تمت كتابتها بحيث تكون قابلة للتوسعة (Adaptive Learning، Progression service، Family session storage لللعب الجماعي).
- مصدر الألغاز المحلي يتعامل مع JSON غير صالح ويعطي رسائل خطأ مفسّرة (`PuzzleDataException`).

**ملفات مهمة للمراجعة السريعة**
- `lib/main.dart`: تهيئة التطبيق وDI.
- `lib/features/game/presentation/bloc/game_bloc.dart`: منطق اللعبة.
- `lib/features/game/domain/services/game_engine_factory.dart`: ربط المحركات.
- `lib/features/game/data/datasources/local_puzzle_datasource.dart`: تحميل الألغاز من `assets/data/puzzles.json`.

**أفكار لتحسين/توسيع**
- إضافة محرر ألغاز داخل التطبيق لتسهيل الإنتاج.
- إضافة اختبارات وحدية ومحاكاة لمحركات الألعاب (وذلك عبر `bloc_test` و`mocktail`).
- دعم تحميل ألغاز من السحابة ومزامنة التقدم بين الأجهزة.

---
إذا ترغب، أستطيع الآن:
- توليد مثال جاهز لمُدخل `puzzles.json` يضم لغزًا من نوع `Mystery Link`.
- تشغيل فحص سطري للملف `assets/data/puzzles.json` إن أردت مني قراءته وتحليله.

انتهى التحليل — أخبرني أي إضافة تريد (مثال: مثال JSON، اختبارات، أو توضيح أي ملف محدد). 

