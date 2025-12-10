import '../game_engine_interface.dart';
import '../../../domain/entities/puzzle.dart';
import '../../../domain/entities/game_type.dart';
import '../../../../../core/constants/game_constants.dart';

/// Engine للعبة Cipher Tiles - كلمات/جمل متعددة
/// كل مستوى يحتوي على كلمة/جملة مختلفة
class CipherTilesEngine implements GameEngine {
  @override
  GameType get gameType => GameType.cipherTiles;

  @override
  bool validateMove({
    required Map<String, dynamic> moveData,
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
  }) {
    final tileId = moveData['tileId'] as String?;
    final decodedChar = moveData['decodedChar'] as String?;

    if (tileId == null || decodedChar == null) return false;
    if (decodedChar.length != 1) return false;

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
    if (!validateMove(
      moveData: moveData,
      puzzle: puzzle,
      currentGameState: currentGameState,
    )) {
      return MoveResult.error('Invalid tile or character');
    }

    final decodedChar = moveData['decodedChar'] as String;
    final currentLevel = currentGameState?['currentLevel'] as int? ?? 1;
    final decodedWord = (currentGameState?['decodedWord'] as String?) ?? '';

    // إضافة الحرف للكلمة
    var updatedDecodedWord = decodedWord + decodedChar;

    // الحصول على الكلمة الصحيحة للمستوى الحالي
    final correctWord = _getLevelWord(puzzle, currentLevel);
    if (correctWord == null) {
      return MoveResult.error('No correct word found for current level');
    }

    final isCorrect = updatedDecodedWord == correctWord;
    int newLevel = currentLevel;
    bool isGameComplete = false;

    if (isCorrect) {
      if (currentLevel < puzzle.linksCount) {
        newLevel = currentLevel + 1;
        // إعادة تعيين الكلمة المشفرة للمستوى الجديد
        updatedDecodedWord = '';
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
        : (updatedDecodedWord.length > correctWord.length ||
                !correctWord.startsWith(updatedDecodedWord))
            ? -GameConstants.basePointsPerStep ~/ 2
            : 0;

    final updatedState = {
      ...?currentGameState,
      'currentLevel': newLevel,
      'decodedWord': updatedDecodedWord,
      'score': currentScore + score,
    };

    return MoveResult.success(
      isCorrect: isCorrect,
      score: score,
      isGameComplete: isGameComplete,
      updatedGameState: updatedState,
    );
  }

  String? _getLevelWord(Puzzle puzzle, int level) {
    if (puzzle.steps.isNotEmpty && level <= puzzle.steps.length) {
      final step = puzzle.steps[level - 1];
      // استخراج الكلمة من options
      final words = step.options.map((opt) => opt.node.label).join(' ');
      return words;
    }

    final allWords = puzzle.gameTypeData?['words'] as List?;
    if (allWords == null) {
      return puzzle.gameTypeData?['decodedWord'] as String?;
    }

    if (level <= allWords.length) {
      return (allWords[level - 1] as Map)['word'] as String?;
    }

    return puzzle.gameTypeData?['decodedWord'] as String?;
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
    if (timeRemaining != null &&
        timeRemaining > GameConstants.timeBonusThreshold) {
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
      'decodedWord': '',
      'score': 0,
    };
  }
}
