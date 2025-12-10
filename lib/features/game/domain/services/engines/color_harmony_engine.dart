import '../game_engine_interface.dart';
import '../../../domain/entities/puzzle.dart';
import '../../../domain/entities/game_type.dart';
import '../../../../../core/constants/game_constants.dart';

/// Engine للعبة Color Harmony
class ColorHarmonyEngine implements GameEngine {
  @override
  GameType get gameType => GameType.colorHarmony;

  @override
  bool validateMove({
    required Map<String, dynamic> moveData,
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
  }) {
    final color1Id = moveData['color1Id'] as String?;
    final color2Id = moveData['color2Id'] as String?;
    
    if (color1Id == null || color2Id == null) return false;
    if (color1Id == color2Id) return false;

    final colors = puzzle.gameTypeData?['colors'] as List?;
    if (colors == null) return false;

    return colors.any((c) => (c as Map)['id'] == color1Id) &&
           colors.any((c) => (c as Map)['id'] == color2Id);
  }

  @override
  MoveResult processMove({
    required Map<String, dynamic> moveData,
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
    int currentStep = 1,
    int currentScore = 0,
  }) {
    if (!validateMove(
      moveData: moveData,
      puzzle: puzzle,
      currentGameState: currentGameState,
    )) {
      return MoveResult.error('Invalid colors');
    }

    final color1Id = moveData['color1Id'] as String;
    final color2Id = moveData['color2Id'] as String;
    final targetColor = puzzle.gameTypeData?['targetColor'] as Map<String, dynamic>?;
    final mixRule = puzzle.gameTypeData?['mixRule'] as String?;

    if (targetColor == null) {
      return MoveResult.error('No target color found');
    }

    // التحقق من صحة المزج
    final isCorrect = _validateColorMix(color1Id, color2Id, mixRule, puzzle);
    final currentLevel = currentGameState?['currentLevel'] as int? ?? 1;
    int newLevel = currentLevel;
    bool isGameComplete = false;

    if (isCorrect) {
      if (currentLevel < puzzle.linksCount) {
        newLevel = currentLevel + 1;
      } else {
        isGameComplete = true;
      }
    }

    final score = isCorrect
        ? calculateScore(
            isCorrect: true,
            puzzle: puzzle,
            currentStep: currentLevel,
            timeRemaining: moveData['timeRemaining'] as int?,
            moveData: moveData,
          )
        : -GameConstants.basePointsPerStep ~/ 2;

    final updatedState = {
      ...?currentGameState,
      'currentLevel': newLevel,
      'mixedColor1': color1Id,
      'mixedColor2': color2Id,
      'score': currentScore + score,
    };

    return MoveResult.success(
      isCorrect: isCorrect,
      score: score,
      isGameComplete: isGameComplete,
      updatedGameState: updatedState,
    );
  }

  bool _validateColorMix(
    String color1Id,
    String color2Id,
    String? mixRule,
    Puzzle puzzle,
  ) {
    // منطق بسيط: يمكن توسيعه
    // للآن، نتحقق من mixRule
    if (mixRule == null) return true;

    final colors = puzzle.gameTypeData?['colors'] as List?;
    if (colors == null) return false;

    final matchingColor1 = colors.where((c) => (c as Map)['id'] == color1Id);
    final color1 = matchingColor1.isEmpty
        ? null
        : matchingColor1.first as Map<String, dynamic>?;

    final matchingColor2 = colors.where((c) => (c as Map)['id'] == color2Id);
    final color2 = matchingColor2.isEmpty
        ? null
        : matchingColor2.first as Map<String, dynamic>?;

    if (color1 == null || color2 == null) return false;

    // مثال: mixRule = "red_blue" يعني Red + Blue = Purple
    final ruleParts = mixRule.split('_');
    if (ruleParts.length == 2) {
      final color1Label = (color1['label'] as String?)?.toLowerCase() ?? '';
      final color2Label = (color2['label'] as String?)?.toLowerCase() ?? '';
      return (color1Label.contains(ruleParts[0]) && color2Label.contains(ruleParts[1])) ||
             (color1Label.contains(ruleParts[1]) && color2Label.contains(ruleParts[0]));
    }

    return true;
  }

  @override
  bool checkWinCondition({
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
    int currentStep = 1,
  }) {
    final currentLevel = currentGameState?['currentLevel'] as int? ?? 1;
    return currentLevel > puzzle.linksCount;
  }

  @override
  int calculateScore({
    required bool isCorrect,
    required Puzzle puzzle,
    int currentStep = 1,
    int? timeRemaining,
    Map<String, dynamic>? moveData,
  }) {
    if (!isCorrect) {
      return -GameConstants.basePointsPerStep ~/ 2;
    }

    int timeBonus = 1;
    if (timeRemaining != null && timeRemaining > GameConstants.timeBonusThreshold) {
      timeBonus = GameConstants.bonusMultiplier;
    }

    // نظام نقاط مشابه لـ Mystery Link
    return GameConstants.basePointsPerStep * puzzle.linksCount * timeBonus;
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
      'currentLevel': 1,
      'mixedColor1': null,
      'mixedColor2': null,
      'score': 0,
    };
  }
}

