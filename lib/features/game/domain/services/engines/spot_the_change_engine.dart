import '../game_engine_interface.dart';
import '../../../domain/entities/puzzle.dart';
import '../../../domain/entities/game_type.dart';
import '../../../../../core/constants/game_constants.dart';

/// Engine للعبة Spot the Change - صور متعددة
/// كل جولة تحتوي على صورة مختلفة
class SpotTheChangeEngine implements GameEngine {
  @override
  GameType get gameType => GameType.spotTheChange;

  @override
  bool validateMove({
    required Map<String, dynamic> moveData,
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
  }) {
    final changeType = moveData['changeType'] as String?;
    final currentRound = currentGameState?['currentRound'] as int? ?? 1;
    
    if (changeType == null) return false;
    if (currentRound < 1 || currentRound > puzzle.linksCount) return false;

    final roundOptions = _getRoundOptions(puzzle, currentRound);
    if (roundOptions == null) return false;

    return roundOptions.any((opt) => (opt as Map)['id'] == changeType);
  }

  List<dynamic>? _getRoundOptions(Puzzle puzzle, int round) {
    if (puzzle.steps.isNotEmpty && round <= puzzle.steps.length) {
      final step = puzzle.steps[round - 1];
      return step.options.map((opt) => {
        'id': opt.node.id,
        'label': opt.node.label,
        'isCorrect': opt.isCorrect,
      }).toList();
    }
    
    final allOptions = puzzle.gameTypeData?['options'] as List?;
    if (allOptions == null) return null;
    
    final optionsPerRound = (allOptions.length / puzzle.linksCount).ceil();
    final startIndex = (round - 1) * optionsPerRound;
    final endIndex = (startIndex + optionsPerRound).clamp(0, allOptions.length);
    
    return allOptions.sublist(startIndex, endIndex);
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
      return MoveResult.error('Invalid change type');
    }

    final changeType = moveData['changeType'] as String;
    final currentRound = currentGameState?['currentRound'] as int? ?? 1;
    final roundOptions = _getRoundOptions(puzzle, currentRound);
    
    if (roundOptions == null) {
      return MoveResult.error('No options found for current round');
    }

    final matchingOptions = roundOptions.where((opt) => (opt as Map)['id'] == changeType);
    final selectedOption = matchingOptions.isEmpty
        ? null
        : matchingOptions.first as Map<String, dynamic>?;

    if (selectedOption == null) {
      return MoveResult.error('Option not found');
    }

    final isCorrect = selectedOption['isCorrect'] == true;
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
      'selectedChangeType': changeType,
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
      'selectedChangeType': null,
      'score': 0,
    };
  }
}

