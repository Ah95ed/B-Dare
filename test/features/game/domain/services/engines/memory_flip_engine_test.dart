import 'package:flutter_test/flutter_test.dart';
import 'package:mystery_link/features/game/domain/services/engines/memory_flip_engine.dart';
import 'package:mystery_link/features/game/domain/entities/puzzle.dart';
import 'package:mystery_link/features/game/domain/entities/link_node.dart';
import 'package:mystery_link/features/game/domain/entities/game_type.dart';

void main() {
  group('MemoryFlipEngine', () {
    late MemoryFlipEngine engine;
    late Puzzle puzzle;

    setUp(() {
      engine = MemoryFlipEngine();
      puzzle = const Puzzle(
        id: 'memory_test',
        gameType: GameType.memoryFlip,
        type: RepresentationType.text,
        start: LinkNode(
            id: 'start',
            label: 'Start',
            representationType: RepresentationType.text),
        end: LinkNode(
            id: 'end',
            label: 'End',
            representationType: RepresentationType.text),
        linksCount: 1,
        timeLimit: 60,
        steps: [],
        gameTypeData: {
          'cards': [
            {'id': 'card1', 'pairId': 'pair1', 'label': 'Apple'},
            {'id': 'card2', 'pairId': 'pair1', 'label': 'Apple'},
            {'id': 'card3', 'pairId': 'pair2', 'label': 'Orange'},
            {'id': 'card4', 'pairId': 'pair2', 'label': 'Orange'},
          ],
        },
      );
    });

    test('should have correct game type', () {
      expect(engine.gameType, GameType.memoryFlip);
    });

    test('should validate card flip', () {
      final isValid = engine.validateMove(
        moveData: {'cardId': 'card1'},
        puzzle: puzzle,
      );

      expect(isValid, true);
    });

    test('should process matching pair', () {
      final currentState = {
        'flippedCards': <String>[],
        'matchedPairs': <String>[],
      };

      // Flip first card
      final result1 = engine.processMove(
        moveData: {'cardId': 'card1', 'timeRemaining': 10},
        puzzle: puzzle,
        currentGameState: currentState,
        currentStep: 1,
        currentScore: 0,
      );

      expect(result1.isValid, true);
      expect(result1.isCorrect, false); // Not matched yet

      // Flip second matching card
      final result2 = engine.processMove(
        moveData: {'cardId': 'card2', 'timeRemaining': 10},
        puzzle: puzzle,
        currentGameState: result1.updatedGameState,
        currentStep: 1,
        currentScore: 0,
      );

      expect(result2.isValid, true);
      expect(result2.isCorrect, true); // Matched!
    });

    test('should initialize game state with shuffled cards', () {
      final gameState = engine.initializeGameState(puzzle);

      expect(gameState['flippedCards'], isA<List>());
      expect(gameState['matchedPairs'], isA<List>());
      expect(gameState['score'], 0);
    });
  });
}
