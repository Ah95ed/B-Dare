# Game Types Architecture

## نظرة عامة

تم تصميم بنية الأنماط لتكون قابلة للتوسيع بسهولة على مدى 20 عاماً. كل نمط له Engine خاص به وWidget خاص به.

## البنية المعمارية

### 1. GameType Enum
- `lib/features/game/domain/entities/game_type.dart`
- يحتوي على 11 نمطاً (Mystery Link + 10 أنماط جديدة)
- Extension methods: `name`, `description`, `icon`, `isTurnBased`, `supportsMultiplayer`

### 2. Game Engine Pattern
كل نمط له Engine خاص به:
- `lib/features/game/domain/services/game_engine_interface.dart` - Interface موحد
- `lib/features/game/domain/services/engines/*.dart` - 11 Engine

**GameEngine Interface Methods:**
- `validateMove()` - التحقق من صحة الحركة
- `processMove()` - معالجة الحركة وإرجاع النتيجة
- `checkWinCondition()` - التحقق من شرط الفوز
- `calculateScore()` - حساب النقاط
- `getGameState()` - الحصول على حالة اللعبة
- `initializeGameState()` - تهيئة حالة اللعبة

### 3. Game Engine Factory
- `lib/features/game/domain/services/game_engine_factory.dart`
- Singleton pattern
- Factory method: `getEngine(GameType)`

### 4. Puzzle Model
- `lib/features/game/domain/entities/puzzle.dart`
- يحتوي على:
  - `gameType: GameType` (default: `GameType.mysteryLink`)
  - `gameTypeData: Map<String, dynamic>?` - بيانات خاصة بكل نمط

### 5. Game Events & States
- `lib/features/game/presentation/bloc/game_event.dart`
  - `GameStarted` - يحتوي على `gameType`
  - Events جديدة: `CardFlipped`, `ItemSelected`, `ItemMoved`, `TileArranged`
  
- `lib/features/game/presentation/bloc/game_state.dart`
  - `GameInProgress` - يحتوي على `gameType` و `gameSpecificData`

### 6. BLoC Integration
- `GameBloc` و `GroupGameBloc` يستخدمان `GameEngineFactory`
- كل event handler يستدعي Engine المناسب

## كيفية إضافة نمط جديد

### الخطوة 1: إضافة GameType
في `lib/features/game/domain/entities/game_type.dart`:
```dart
enum GameType {
  // ... الأنماط الموجودة
  newGameType,
}

extension GameTypeExtension on GameType {
  // إضافة name, description, icon, value, etc.
}
```

### الخطوة 2: إنشاء Engine
إنشاء ملف جديد: `lib/features/game/domain/services/engines/new_game_type_engine.dart`
```dart
class NewGameTypeEngine implements GameEngine {
  @override
  GameType get gameType => GameType.newGameType;
  
  // تنفيذ جميع methods من GameEngine interface
}
```

### الخطوة 3: إضافة Engine إلى Factory
في `lib/features/game/domain/services/game_engine_factory.dart`:
```dart
case GameType.newGameType:
  return NewGameTypeEngine();
```

### الخطوة 4: إنشاء UI Widget
إنشاء ملف جديد: `lib/features/game/presentation/widgets/new_game_type_widget.dart`

### الخطوة 5: تحديث GameScreen
في `lib/features/game/presentation/screens/game_screen.dart`:
```dart
Widget _buildGameContent(GameInProgress state) {
  switch (state.gameType) {
    case GameType.newGameType:
      return NewGameTypeWidget(state: state);
    // ... الأنماط الأخرى
  }
}
```

### الخطوة 6: إضافة Event (إذا لزم الأمر)
إذا كان النمط يحتاج event جديد، أضفه في `game_event.dart`

### الخطوة 7: إضافة Puzzles
في `assets/data/puzzles.json`:
```json
{
  "id": "new_game_type_1",
  "gameType": "newGameType",
  "gameTypeData": {
    // بيانات خاصة بالنمط
  }
}
```

## Best Practices

1. **Separation of Concerns**: كل Engine مستقل تماماً
2. **Type Safety**: استخدام enums و type checking في كل مكان
3. **Backward Compatibility**: جميع puzzles القديمة تعمل بدون `gameType` (default: mysteryLink)
4. **Cloudflare Ready**: جميع الأنماط تدعم multiplayer من البداية
5. **Extensibility**: إضافة نمط جديد = إنشاء Engine جديد + Widget جديد فقط

## الأنماط المدعومة

1. **Mystery Link** - النمط الأصلي
2. **Memory Flip** - ذاكرة البطاقات
3. **Spot the Odd** - اكتشف المختلف
4. **Sort & Solve** - الترتيب والحل
5. **Story Tiles** - بلاطات القصة
6. **Shadow Match** - مطابقة الظلال
7. **Emoji Circuit** - دائرة الإيموجي
8. **Cipher Tiles** - بلاطات الشفرة
9. **Spot the Change** - اكتشف التغيير
10. **Color Harmony** - انسجام الألوان
11. **Puzzle Sentence** - جملة الأحجية

