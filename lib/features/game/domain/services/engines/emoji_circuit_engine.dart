import '../game_engine_interface.dart';
import '../../../domain/entities/puzzle.dart';
import '../../../domain/entities/game_type.dart';
import '../../../../../core/constants/game_constants.dart';

/// Engine للعبة Emoji Circuit - دوائر متعددة
/// كل دائرة تحتوي على مجموعة إيموجي مختلفة
class EmojiCircuitEngine implements GameEngine {
  @override
  GameType get gameType => GameType.emojiCircuit;

  @override
  bool validateMove({
    required Map<String, dynamic> moveData,
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
  }) {
    final emojiId = moveData['emojiId'] as String?;
    final nextEmojiId = moveData['nextEmojiId'] as String?;

    if (emojiId == null || nextEmojiId == null) return false;

    final emojis = puzzle.gameTypeData?['emojis'] as List?;
    if (emojis == null) return false;

    return emojis.any((e) => (e as Map)['id'] == emojiId) &&
        emojis.any((e) => (e as Map)['id'] == nextEmojiId);
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
      return MoveResult.error('Invalid emoji connection');
    }

    final emojiId = moveData['emojiId'] as String;
    final nextEmojiId = moveData['nextEmojiId'] as String;
    final connections = (currentGameState?['connections'] as List?) ?? [];

    // إضافة الاتصال
    final newConnection = {'from': emojiId, 'to': nextEmojiId};
    var updatedConnections = [...connections, newConnection];

    // التحقق من صحة الاتصال (حسب القاعدة)
    final rule = puzzle.gameTypeData?['rule'] as String?;
    final bool isCorrect =
        _validateConnection(emojiId, nextEmojiId, puzzle, rule);

    // التحقق من اكتمال الدائرة
    final currentCircuit = currentGameState?['currentCircuit'] as int? ?? 1;
    final circuitEmojis = _getCircuitEmojis(puzzle, currentCircuit);

    bool isCircuitComplete = false;
    bool isGameComplete = false;
    int newCircuit = currentCircuit;

    if (isCorrect && circuitEmojis != null) {
      isCircuitComplete =
          updatedConnections.length >= (circuitEmojis.length - 1);

      if (isCircuitComplete) {
        if (currentCircuit < puzzle.linksCount) {
          newCircuit = currentCircuit + 1;
          // إعادة تعيين الاتصالات للدائرة الجديدة
          updatedConnections = [];
        } else {
          isGameComplete = true;
        }
      }
    }

    final score = isCorrect
        ? calculateScore(
            isCorrect: true,
            puzzle: puzzle,
            currentStep: currentCircuit,
            timeRemaining: moveData['timeRemaining'] as int?,
            moveData: moveData,
          )
        : -GameConstants.basePointsPerStep ~/ 2;

    final updatedState = {
      ...?currentGameState,
      'currentCircuit': newCircuit,
      'connections': updatedConnections,
      'score': currentScore + score,
    };

    return MoveResult.success(
      isCorrect: isCorrect,
      score: score,
      isGameComplete: isGameComplete,
      updatedGameState: updatedState,
    );
  }

  List<dynamic>? _getCircuitEmojis(Puzzle puzzle, int circuit) {
    if (puzzle.steps.isNotEmpty && circuit <= puzzle.steps.length) {
      final step = puzzle.steps[circuit - 1];
      return step.options
          .map((opt) => {
                'id': opt.node.id,
                'label': opt.node.label,
              })
          .toList();
    }

    final allEmojis = puzzle.gameTypeData?['emojis'] as List?;
    if (allEmojis == null) return null;

    final emojisPerCircuit = (allEmojis.length / puzzle.linksCount).ceil();
    final startIndex = (circuit - 1) * emojisPerCircuit;
    final endIndex = (startIndex + emojisPerCircuit).clamp(0, allEmojis.length);

    return allEmojis.sublist(startIndex, endIndex);
  }

  bool _validateConnection(
    String emojiId1,
    String emojiId2,
    Puzzle puzzle,
    String? rule,
  ) {
    // منطق بسيط: يمكن توسيعه حسب القواعد المختلفة
    // للآن، نعتبر أي اتصال صحيح (سيتم تطويره لاحقاً)
    return true;
  }

  @override
  bool checkWinCondition({
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
    int currentStep = 1,
  }) {
    final currentCircuit = currentGameState?['currentCircuit'] as int? ?? 1;
    return currentCircuit > puzzle.linksCount;
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
      'currentCircuit': 1,
      'connections': <Map<String, String>>[],
      'score': 0,
    };
  }
}
