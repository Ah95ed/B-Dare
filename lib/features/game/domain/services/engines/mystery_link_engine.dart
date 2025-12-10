import '../game_engine_interface.dart';
import '../../../domain/entities/puzzle.dart';
import '../../../domain/entities/game_type.dart';
import '../../../../../core/constants/game_constants.dart';

/// Engine للعبة Mystery Link (النمط الأصلي)
class MysteryLinkEngine implements GameEngine {
  @override
  GameType get gameType => GameType.mysteryLink;

  @override
  bool validateMove({
    required Map<String, dynamic> moveData,
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
  }) {
    final selectedNodeId = moveData['selectedNodeId'] as String?;
    final stepOrder = moveData['stepOrder'] as int?;
    
    if (selectedNodeId == null || stepOrder == null) {
      return false;
    }

    if (stepOrder < 1 || stepOrder > puzzle.steps.length) {
      return false;
    }

    final step = puzzle.steps[stepOrder - 1];
    return step.options.any((option) => option.node.id == selectedNodeId);
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

    final selectedNodeId = moveData['selectedNodeId'] as String;
    final stepOrder = moveData['stepOrder'] as int;
    final step = puzzle.steps[stepOrder - 1];
    final correctOption = step.correctOption;

    if (correctOption == null) {
      return MoveResult.error('No correct option found');
    }

    final isCorrect = correctOption.node.id == selectedNodeId;
    final newStep = currentStep + 1;
    final isGameComplete = newStep > puzzle.linksCount;

    final timeRemaining = moveData['timeRemaining'] as int?;
    final score = isCorrect
        ? calculateScore(
            isCorrect: true,
            puzzle: puzzle,
            currentStep: stepOrder,
            timeRemaining: timeRemaining,
            moveData: moveData,
          )
        : -GameConstants.basePointsPerStep ~/ 2;

    final updatedState = {
      ...?currentGameState,
      'currentStep': newStep,
      'chosenNodes': [
        ...?(currentGameState?['chosenNodes'] as List?),
        if (isCorrect) selectedNodeId,
      ],
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
    return currentStep > puzzle.linksCount;
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
      'currentStep': 1,
      'chosenNodes': <String>[],
      'score': 0,
    };
  }
}

