# دليل إضافة نمط لعب جديد

هذا الدليل يشرح خطوة بخطوة كيفية إضافة نمط لعب جديد إلى النظام.

## الخطوات

### 1. إضافة GameType

في `lib/features/game/domain/entities/game_type.dart`:

```dart
enum GameType {
  // ... الأنماط الموجودة
  newGameType, // أضف هنا
}

extension GameTypeExtension on GameType {
  String get name {
    switch (this) {
      // ... الحالات الموجودة
      case GameType.newGameType:
        return 'اسم النمط بالعربية';
    }
  }

  String get description {
    switch (this) {
      // ... الحالات الموجودة
      case GameType.newGameType:
        return 'وصف النمط';
    }
  }

  IconData get icon {
    switch (this) {
      // ... الحالات الموجودة
      case GameType.newGameType:
        return Icons.your_icon;
    }
  }

  String get value {
    switch (this) {
      // ... الحالات الموجودة
      case GameType.newGameType:
        return 'newGameType';
    }
  }

  static GameType? fromString(String? value) {
    switch (value?.toLowerCase()) {
      // ... الحالات الموجودة
      case 'newgametype':
      case 'new_game_type':
        return GameType.newGameType;
    }
  }
}
```

### 2. إنشاء Game Engine

إنشاء ملف جديد: `lib/features/game/domain/services/engines/new_game_type_engine.dart`

```dart
import '../game_engine_interface.dart';
import '../../../domain/entities/puzzle.dart';
import '../../../domain/entities/game_type.dart';
import '../../../../../core/constants/game_constants.dart';

class NewGameTypeEngine implements GameEngine {
  @override
  GameType get gameType => GameType.newGameType;

  @override
  bool validateMove({
    required Map<String, dynamic> moveData,
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
  }) {
    // منطق التحقق من صحة الحركة
    return true;
  }

  @override
  MoveResult processMove({
    required Map<String, dynamic> moveData,
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
    int currentStep = 1,
    int currentScore = 0,
  }) {
    // منطق معالجة الحركة
    return MoveResult.success(
      isCorrect: true,
      score: 100,
      isGameComplete: false,
    );
  }

  @override
  bool checkWinCondition({
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
    int currentStep = 1,
  }) {
    // منطق التحقق من الفوز
    return false;
  }

  @override
  int calculateScore({
    required bool isCorrect,
    required Puzzle puzzle,
    int currentStep = 1,
    int? timeRemaining,
    Map<String, dynamic>? moveData,
  }) {
    // منطق حساب النقاط
    return isCorrect ? 100 : -50;
  }

  @override
  Map<String, dynamic>? getGameState({
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
    Map<String, dynamic>? moveData,
  }) {
    return currentGameState;
  }

  @override
  Map<String, dynamic> initializeGameState(Puzzle puzzle) {
    return {
      'score': 0,
      // بيانات خاصة بالنمط
    };
  }
}
```

### 3. إضافة Engine إلى Factory

في `lib/features/game/domain/services/game_engine_factory.dart`:

```dart
import 'engines/new_game_type_engine.dart';

// في _createEngine method:
case GameType.newGameType:
  return NewGameTypeEngine();
```

### 4. إنشاء UI Widget

إنشاء ملف جديد: `lib/features/game/presentation/widgets/new_game_type_widget.dart`

```dart
import 'package:flutter/material.dart';
import '../bloc/game_state.dart';
import '../bloc/game_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/base_game_bloc.dart';

class NewGameTypeWidget extends StatelessWidget {
  final GameInProgress state;

  const NewGameTypeWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    // UI الخاص بالنمط
    return Container();
  }
}
```

### 5. تحديث GameScreen

في `lib/features/game/presentation/screens/game_screen.dart`:

```dart
import '../widgets/new_game_type_widget.dart';

// في _buildGameContent method:
case GameType.newGameType:
  return NewGameTypeWidget(state: state);
```

### 6. إضافة Event (إذا لزم الأمر)

إذا كان النمط يحتاج event جديد، أضفه في `lib/features/game/presentation/bloc/game_event.dart`:

```dart
class NewGameTypeAction extends GameEvent {
  final String actionData;

  const NewGameTypeAction({required this.actionData});

  @override
  List<Object?> get props => [actionData];
}
```

### 7. إضافة Handler في BLoC

في `lib/features/game/presentation/bloc/game_bloc.dart`:

```dart
on<NewGameTypeAction>(_onNewGameTypeAction);

Future<void> _onNewGameTypeAction(
  NewGameTypeAction event,
  Emitter<GameState> emit,
) async {
  // معالجة الـ event
}
```

### 8. إضافة Puzzles

في `assets/data/puzzles.json`:

```json
{
  "id": "new_game_type_1",
  "gameType": "newGameType",
  "type": "text",
  "category": "General Knowledge",
  "difficulty": "easy",
  "linksCount": 1,
  "timeLimit": 60,
  "start": {
    "id": "start",
    "label": "Start",
    "representationType": "text"
  },
  "end": {
    "id": "end",
    "label": "End",
    "representationType": "text"
  },
  "steps": [],
  "gameTypeData": {
    // بيانات خاصة بالنمط
  }
}
```

### 9. تحديث Backend (Cloudflare)

في `backend/src/GameRoom.ts`:

```typescript
// في initializeGameSpecificData:
case 'newGameType':
  return {
    // بيانات خاصة
  };

// في handleMessage:
case 'newGameTypeAction':
  await this.handleNewGameTypeAction(playerId, message);
  break;
```

### 10. تحديث MultiplayerService

في `lib/features/multiplayer/data/services/cloudflare_multiplayer_service.dart`:

```dart
Future<void> newGameTypeAction({
  required String actionData,
  Map<String, dynamic>? gameSpecificData,
}) async {
  await sendMessage({
    'type': 'newGameTypeAction',
    'actionData': actionData,
    ...?gameSpecificData,
  });
}
```

## Checklist

- [ ] إضافة GameType enum
- [ ] إنشاء Game Engine
- [ ] إضافة Engine إلى Factory
- [ ] إنشاء UI Widget
- [ ] تحديث GameScreen
- [ ] إضافة Events (إذا لزم الأمر)
- [ ] إضافة Handlers في BLoC
- [ ] إضافة Puzzles أمثلة
- [ ] تحديث Backend
- [ ] تحديث MultiplayerService
- [ ] كتابة Tests
- [ ] تحديث Documentation

## Tips

1. ابدأ بإنشاء Engine أولاً - هذا هو القلب المنطقي للنمط
2. استخدم الأمثلة الموجودة كمرجع
3. تأكد من backward compatibility
4. اختبر كل خطوة قبل الانتقال للخطوة التالية
5. اكتب tests لكل Engine

