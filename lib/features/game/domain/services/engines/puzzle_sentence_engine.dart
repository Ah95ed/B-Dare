import '../game_engine_interface.dart';
import '../../../domain/entities/puzzle.dart';
import '../../../domain/entities/game_type.dart';
import '../../../../../core/constants/game_constants.dart';

/// Engine للعبة Puzzle Sentence - جمل متعددة
/// كل مستوى يحتوي على جملة مختلفة
class PuzzleSentenceEngine implements GameEngine {
  @override
  GameType get gameType => GameType.puzzleSentence;

  @override
  bool validateMove({
    required Map<String, dynamic> moveData,
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
  }) {
    final wordId = moveData['wordId'] as String?;
    final newPosition = moveData['newPosition'] as int?;
    
    if (wordId == null || newPosition == null) return false;
    if (newPosition < 0) return false;

    final words = puzzle.gameTypeData?['words'] as List?;
    if (words == null) return false;

    return newPosition < words.length;
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

    final wordId = moveData['wordId'] as String;
    final newPosition = moveData['newPosition'] as int;
    final currentOrder = (currentGameState?['currentOrder'] as List?) ?? [];

    // تحديث الترتيب
    var updatedOrder = List<String>.from(currentOrder);
    updatedOrder.remove(wordId);
    updatedOrder.insert(newPosition, wordId);

    // بناء الجملة
    final words = puzzle.gameTypeData?['words'] as List?;
    if (words == null) {
      return MoveResult.error('No words found');
    }

    final sentence = updatedOrder
        .map((id) {
          final matchingWords = words.where((w) => (w as Map)['id'] == id);
          if (matchingWords.isEmpty) return '';
          final word = matchingWords.first as Map<String, dynamic>;
          return word['label'] as String? ?? '';
        })
        .join(' ');

    // التحقق من الجملة الصحيحة
    final correctSentence = puzzle.gameTypeData?['correctSentence'] as String?;
    if (correctSentence == null) {
      return MoveResult.error('No correct sentence found');
    }

    final isCorrect = sentence.trim().toLowerCase() == correctSentence.trim().toLowerCase();
    final currentLevel = currentGameState?['currentLevel'] as int? ?? 1;
    int newLevel = currentLevel;
    bool isGameComplete = false;

    if (isCorrect) {
      if (currentLevel < puzzle.linksCount) {
        newLevel = currentLevel + 1;
        // إعادة تعيين الترتيب للجملة الجديدة
        updatedOrder = [];
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
      'sentence': sentence,
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
      'sentence': '',
      'score': 0,
    };
  }
}

