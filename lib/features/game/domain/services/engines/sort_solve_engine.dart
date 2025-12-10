import '../game_engine_interface.dart';
import '../../../domain/entities/puzzle.dart';
import '../../../domain/entities/game_type.dart';
import '../../../../../core/constants/game_constants.dart';

/// Engine للعبة Sort & Solve - متعدد المستويات
/// كل مستوى يحتوي على مجموعة ترتيب مختلفة
class SortSolveEngine implements GameEngine {
  @override
  GameType get gameType => GameType.sortSolve;

  @override
  bool validateMove({
    required Map<String, dynamic> moveData,
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
  }) {
    final itemId = moveData['itemId'] as String?;
    final newPosition = moveData['newPosition'] as int?;
    
    if (itemId == null || newPosition == null) return false;
    if (newPosition < 0) return false;

    final items = puzzle.gameTypeData?['items'] as List?;
    if (items == null) return false;

    return newPosition < items.length;
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
      return MoveResult.error('Invalid move');
    }

    final itemId = moveData['itemId'] as String;
    final newPosition = moveData['newPosition'] as int;
    final currentOrder = (currentGameState?['currentOrder'] as List?) ?? [];

    // تحديث الترتيب
    final updatedOrder = List<String>.from(currentOrder);
    updatedOrder.remove(itemId);
    updatedOrder.insert(newPosition, itemId);

    // التحقق من الترتيب الصحيح
    final items = puzzle.gameTypeData?['items'] as List?;
    if (items == null) {
      return MoveResult.error('No items found');
    }

    // ترتيب حسب order field
    final sortedItemsList = List.from(items);
    sortedItemsList.sort((a, b) {
      final orderA = (a as Map)['order'] as int? ?? 0;
      final orderB = (b as Map)['order'] as int? ?? 0;
      return orderA.compareTo(orderB);
    });

    final sortedCorrectOrder = sortedItemsList
        .map((item) => (item as Map)['id'] as String)
        .toList();

    final isCorrect = _compareOrders(updatedOrder, sortedCorrectOrder);
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
        : 0;

    final updatedState = {
      ...?currentGameState,
      'currentLevel': newLevel,
      'currentOrder': updatedOrder,
      'score': currentScore + score,
    };

    return MoveResult.success(
      isCorrect: isCorrect,
      score: score,
      isGameComplete: isGameComplete,
      updatedGameState: updatedState,
    );
  }

  bool _compareOrders(List<String> order1, List<String> order2) {
    if (order1.length != order2.length) return false;
    for (int i = 0; i < order1.length; i++) {
      if (order1[i] != order2[i]) return false;
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
    if (!isCorrect) return 0;
    
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
      'currentOrder': <String>[],
      'score': 0,
    };
  }
}

