import '../game_engine_interface.dart';
import '../../../domain/entities/puzzle.dart';
import '../../../domain/entities/game_type.dart';
import '../../../../../core/constants/game_constants.dart';

/// Engine للعبة Memory Flip - متعدد المستويات
/// كل مستوى يحتوي على مجموعة بطاقات مختلفة
class MemoryFlipEngine implements GameEngine {
  @override
  GameType get gameType => GameType.memoryFlip;

  @override
  bool validateMove({
    required Map<String, dynamic> moveData,
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
  }) {
    final cardId = moveData['cardId'] as String?;
    final level = currentGameState?['currentLevel'] as int? ?? 1;
    
    if (cardId == null) return false;
    if (level < 1 || level > puzzle.linksCount) return false;

    // الحصول على بطاقات المستوى الحالي
    final levelCards = _getLevelCards(puzzle, level);
    if (levelCards == null) return false;

    return levelCards.any((card) => (card as Map)['id'] == cardId);
  }

  List<dynamic>? _getLevelCards(Puzzle puzzle, int level) {
    // إذا كان puzzle.steps موجود، استخدمه (مثل Mystery Link)
    if (puzzle.steps.isNotEmpty && level <= puzzle.steps.length) {
      final step = puzzle.steps[level - 1];
      // استخراج البطاقات من options
      return step.options.map((opt) => {
        'id': opt.node.id,
        'label': opt.node.label,
        'pairId': _getPairIdForNode(opt.node, step),
      }).toList();
    }
    
    // Fallback إلى gameTypeData
    final allCards = puzzle.gameTypeData?['cards'] as List?;
    if (allCards == null) return null;
    
    // تقسيم البطاقات إلى مستويات
    final cardsPerLevel = (allCards.length / puzzle.linksCount).ceil();
    final startIndex = (level - 1) * cardsPerLevel;
    final endIndex = (startIndex + cardsPerLevel).clamp(0, allCards.length);
    
    return allCards.sublist(startIndex, endIndex);
  }

  String _getPairIdForNode(linkNode, step) {
    // البحث عن البطاقة المطابقة في نفس الخطوة
    final matchingOption = step.options.firstWhere(
      (opt) => opt.node.id != linkNode.id && 
               opt.isCorrect == true,
      orElse: () => step.options.first,
    );
    return 'pair_${step.order}_${linkNode.id}_${matchingOption.node.id}';
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
      return MoveResult.error('Invalid card');
    }

    final cardId = moveData['cardId'] as String;
    final currentLevel = currentGameState?['currentLevel'] as int? ?? 1;
    final levelCards = _getLevelCards(puzzle, currentLevel);
    
    if (levelCards == null) {
      return MoveResult.error('No cards found for current level');
    }

    final matchingCards = levelCards.where((c) => (c as Map)['id'] == cardId);
    final card = matchingCards.isEmpty
        ? null
        : matchingCards.first as Map<String, dynamic>?;

    if (card == null) {
      return MoveResult.error('Card not found');
    }

    final flippedCards = (currentGameState?['flippedCards'] as List?)?.cast<String>() ?? <String>[];
    final matchedPairs = (currentGameState?['matchedPairs'] as List?)?.cast<String>() ?? <String>[];

    // إذا كانت البطاقة مقلوبة بالفعل أو متطابقة، تجاهل
    if (flippedCards.contains(cardId) || matchedPairs.contains(card['pairId'])) {
      return MoveResult.error('Card already flipped or matched');
    }

    final newFlippedCards = [...flippedCards, cardId];
    bool isMatch = false;
    List<String> updatedFlippedCards = newFlippedCards;
    List<String> updatedMatchedPairs = matchedPairs;
    int newLevel = currentLevel;
    bool isLevelComplete = false;

    // إذا كان هناك بطاقتان مقلوبتان، تحقق من التطابق
    if (newFlippedCards.length == 2) {
      final card1 = levelCards.firstWhere(
        (c) => (c as Map)['id'] == newFlippedCards[0],
      ) as Map<String, dynamic>;
      final card2 = levelCards.firstWhere(
        (c) => (c as Map)['id'] == newFlippedCards[1],
      ) as Map<String, dynamic>;

      if (card1['pairId'] == card2['pairId']) {
        // تطابق!
        isMatch = true;
        updatedMatchedPairs = [...matchedPairs, card1['pairId'] as String];
        updatedFlippedCards = [];
        
        // التحقق من اكتمال المستوى
        final totalPairs = (levelCards.length / 2).floor();
        isLevelComplete = updatedMatchedPairs.length >= totalPairs;
        
        if (isLevelComplete && currentLevel < puzzle.linksCount) {
          // الانتقال للمستوى التالي
          newLevel = currentLevel + 1;
          updatedMatchedPairs = []; // إعادة تعيين للمستوى الجديد
        }
      } else {
        // لا تطابق - إعادة البطاقات
        updatedFlippedCards = [];
      }
    }

    final isGameComplete = isLevelComplete && newLevel > puzzle.linksCount;

    int? score;
    if (isMatch) {
      score = calculateScore(
        isCorrect: true,
        puzzle: puzzle,
        currentStep: currentLevel,
        timeRemaining: moveData['timeRemaining'] as int?,
        moveData: moveData,
      );
    }

    final updatedState = {
      ...?currentGameState,
      'currentLevel': newLevel,
      'flippedCards': updatedFlippedCards,
      'matchedPairs': updatedMatchedPairs,
      'score': currentScore + (score ?? 0),
    };

    return MoveResult.success(
      isCorrect: isMatch,
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

    // نظام نقاط مشابه لـ Mystery Link: نقاط أساسية × عدد المستويات × مكافأة الوقت
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
      'flippedCards': <String>[],
      'matchedPairs': <String>[],
      'score': 0,
    };
  }
}

