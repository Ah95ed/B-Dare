import '../game_engine_interface.dart';
import '../../../domain/entities/puzzle.dart';
import '../../../domain/entities/game_type.dart';
import '../../../../../core/constants/game_constants.dart';

/// Engine للعبة Shadow Match - متعدد الجولات
/// كل جولة تحتوي على مجموعة ظلال مختلفة
class ShadowMatchEngine implements GameEngine {
  @override
  GameType get gameType => GameType.shadowMatch;

  @override
  bool validateMove({
    required Map<String, dynamic> moveData,
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
  }) {
    final shadowId = moveData['shadowId'] as String?;
    final currentRound = currentGameState?['currentRound'] as int? ?? 1;
    
    if (shadowId == null) return false;
    if (currentRound < 1 || currentRound > puzzle.linksCount) return false;

    final roundShadows = _getRoundShadows(puzzle, currentRound);
    if (roundShadows == null) return false;

    return roundShadows.any((shadow) => (shadow as Map)['id'] == shadowId);
  }

  List<dynamic>? _getRoundShadows(Puzzle puzzle, int round) {
    if (puzzle.steps.isNotEmpty && round <= puzzle.steps.length) {
      final step = puzzle.steps[round - 1];
      return step.options.map((opt) => {
        'id': opt.node.id,
        'label': opt.node.label,
        'isCorrect': opt.isCorrect,
      }).toList();
    }
    
    final allShadows = puzzle.gameTypeData?['shadows'] as List?;
    if (allShadows == null) return null;
    
    final shadowsPerRound = (allShadows.length / puzzle.linksCount).ceil();
    final startIndex = (round - 1) * shadowsPerRound;
    final endIndex = (startIndex + shadowsPerRound).clamp(0, allShadows.length);
    
    return allShadows.sublist(startIndex, endIndex);
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
      return MoveResult.error('Invalid shadow');
    }

    final shadowId = moveData['shadowId'] as String;
    final currentRound = currentGameState?['currentRound'] as int? ?? 1;
    final roundShadows = _getRoundShadows(puzzle, currentRound);
    
    if (roundShadows == null) {
      return MoveResult.error('No shadows found for current round');
    }

    final matchingShadows = roundShadows.where((s) => (s as Map)['id'] == shadowId);
    final selectedShadow = matchingShadows.isEmpty
        ? null
        : matchingShadows.first as Map<String, dynamic>?;

    if (selectedShadow == null) {
      return MoveResult.error('Shadow not found');
    }

    final isCorrect = selectedShadow['isCorrect'] == true;
    int newRound = currentRound;
    bool isGameComplete = false;

    if (isCorrect) {
      if (currentRound < puzzle.linksCount) {
        newRound = currentRound + 1;
      } else {
        isGameComplete = true;
      }
    }

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
      'selectedShadowId': shadowId,
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
      'selectedShadowId': null,
      'score': 0,
    };
  }
}

