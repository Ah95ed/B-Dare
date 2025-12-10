import '../game_engine_interface.dart';
import '../../../domain/entities/puzzle.dart';
import '../../../domain/entities/game_type.dart';
import '../../../../../core/constants/game_constants.dart';

/// Engine للعبة Spot the Odd - متعدد الجولات
/// كل جولة تحتوي على مجموعة عناصر مختلفة
class SpotTheOddEngine implements GameEngine {
  @override
  GameType get gameType => GameType.spotTheOdd;

  @override
  bool validateMove({
    required Map<String, dynamic> moveData,
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
  }) {
    final selectedItemId = moveData['selectedItemId'] as String?;
    final currentRound = currentGameState?['currentRound'] as int? ?? 1;
    
    if (selectedItemId == null) return false;
    if (currentRound < 1 || currentRound > puzzle.linksCount) return false;

    final roundItems = _getRoundItems(puzzle, currentRound);
    if (roundItems == null) return false;

    return roundItems.any((item) => (item as Map)['id'] == selectedItemId);
  }

  List<dynamic>? _getRoundItems(Puzzle puzzle, int round) {
    // إذا كان puzzle.steps موجود، استخدمه (مثل Mystery Link)
    if (puzzle.steps.isNotEmpty && round <= puzzle.steps.length) {
      final step = puzzle.steps[round - 1];
      // استخراج العناصر من options
      return step.options.map((opt) => {
        'id': opt.node.id,
        'label': opt.node.label,
        'isCorrect': opt.isCorrect,
      }).toList();
    }
    
    // Fallback إلى gameTypeData
    final allItems = puzzle.gameTypeData?['items'] as List?;
    if (allItems == null) return null;
    
    // تقسيم العناصر إلى جولات
    final itemsPerRound = (allItems.length / puzzle.linksCount).ceil();
    final startIndex = (round - 1) * itemsPerRound;
    final endIndex = (startIndex + itemsPerRound).clamp(0, allItems.length);
    
    return allItems.sublist(startIndex, endIndex);
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
      return MoveResult.error('Invalid item');
    }

    final selectedItemId = moveData['selectedItemId'] as String;
    final currentRound = currentGameState?['currentRound'] as int? ?? 1;
    final roundItems = _getRoundItems(puzzle, currentRound);
    
    if (roundItems == null) {
      return MoveResult.error('No items found for current round');
    }

    // البحث عن الإجابة الصحيحة في الجولة الحالية
    final matchingItems = roundItems.where((item) => (item as Map)['isCorrect'] == true);
    final correctItem = matchingItems.isEmpty
        ? null
        : matchingItems.first as Map<String, dynamic>?;

    if (correctItem == null) {
      return MoveResult.error('No correct answer found');
    }

    final isCorrect = selectedItemId == correctItem['id'];
    int newRound = currentRound;
    bool isRoundComplete = false;

    if (isCorrect) {
      isRoundComplete = true;
      if (currentRound < puzzle.linksCount) {
        newRound = currentRound + 1;
      }
    }

    final isGameComplete = isRoundComplete && newRound > puzzle.linksCount;

    final score = isCorrect
        ? calculateScore(
            isCorrect: true,
            puzzle: puzzle,
            currentStep: currentRound,
            timeRemaining: moveData['timeRemaining'] as int?,
            moveData: moveData,
          )
        : -GameConstants.basePointsPerStep ~/ 2;

    final updatedState = {
      ...?currentGameState,
      'currentRound': newRound,
      'selectedItemId': selectedItemId,
      'score': currentScore + score,
    };

    return MoveResult.success(
      isCorrect: isCorrect,
      score: score,
      isGameComplete: isGameComplete,
      updatedGameState: updatedState,
    );
  }

  @override
  bool checkWinCondition({
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
    int currentStep = 1,
  }) {
    final currentRound = currentGameState?['currentRound'] as int? ?? 1;
    return currentRound > puzzle.linksCount;
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
      'currentRound': 1,
      'selectedItemId': null,
      'score': 0,
    };
  }
}

