import '../game_engine_interface.dart';
import '../../../domain/entities/puzzle.dart';
import '../../../domain/entities/game_type.dart';
import '../../../../../core/constants/game_constants.dart';

/// Engine للعبة Story Tiles - متعدد الفصول
/// كل فصل يحتوي على مجموعة قطع مختلفة
class StoryTilesEngine implements GameEngine {
  @override
  GameType get gameType => GameType.storyTiles;

  @override
  bool validateMove({
    required Map<String, dynamic> moveData,
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
  }) {
    final tileId = moveData['tileId'] as String?;
    final newPosition = moveData['newPosition'] as int?;
    
    if (tileId == null || newPosition == null) return false;
    if (newPosition < 0) return false;

    final tiles = puzzle.gameTypeData?['tiles'] as List?;
    if (tiles == null) return false;

    return newPosition < tiles.length;
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

    final tileId = moveData['tileId'] as String;
    final newPosition = moveData['newPosition'] as int;
    final currentOrder = (currentGameState?['currentOrder'] as List?) ?? [];

    // تحديث الترتيب
    final updatedOrder = List<String>.from(currentOrder);
    updatedOrder.remove(tileId);
    updatedOrder.insert(newPosition, tileId);

    // التحقق من الترتيب الصحيح
    final tiles = puzzle.gameTypeData?['tiles'] as List?;
    if (tiles == null) {
      return MoveResult.error('No tiles found');
    }

    final sortedTiles = List.from(tiles);
    sortedTiles.sort((a, b) {
      final orderA = (a as Map)['order'] as int? ?? 0;
      final orderB = (b as Map)['order'] as int? ?? 0;
      return orderA.compareTo(orderB);
    });

    final correctOrder = sortedTiles
        .map((tile) => (tile as Map)['id'] as String)
        .toList();

    final isCorrect = _compareOrders(updatedOrder, correctOrder);
    final currentChapter = currentGameState?['currentChapter'] as int? ?? 1;
    int newChapter = currentChapter;
    bool isGameComplete = false;

    if (isCorrect) {
      if (currentChapter < puzzle.linksCount) {
        newChapter = currentChapter + 1;
      } else {
        isGameComplete = true;
      }
    }

    final score = isCorrect
        ? calculateScore(
            isCorrect: true,
            puzzle: puzzle,
            currentStep: currentChapter,
            timeRemaining: moveData['timeRemaining'] as int?,
            moveData: moveData,
          )
        : 0;

    final updatedState = {
      ...?currentGameState,
      'currentChapter': newChapter,
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
    final currentChapter = currentGameState?['currentChapter'] as int? ?? 1;
    return currentChapter > puzzle.linksCount;
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
      'currentChapter': 1,
      'currentOrder': <String>[],
      'score': 0,
    };
  }
}

