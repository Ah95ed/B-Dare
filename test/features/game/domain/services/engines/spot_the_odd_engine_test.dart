import 'package:flutter_test/flutter_test.dart';
import 'package:mystery_link/features/game/domain/services/engines/spot_the_odd_engine.dart';
import 'package:mystery_link/features/game/domain/entities/puzzle.dart';
import 'package:mystery_link/features/game/domain/entities/link_node.dart';
import 'package:mystery_link/features/game/domain/entities/game_type.dart';

void main() {
  group('SpotTheOddEngine', () {
    late SpotTheOddEngine engine;
    late Puzzle puzzle;

    setUp(() {
      engine = SpotTheOddEngine();
      puzzle = const Puzzle(
        id: 'test_puzzle',
        gameType: GameType.spotTheOdd,
        type: RepresentationType.text,
        start: LinkNode(
          id: 'start',
          label: 'Start',
          representationType: RepresentationType.text,
        ),
        end: LinkNode(
          id: 'end',
          label: 'End',
          representationType: RepresentationType.text,
        ),
        linksCount: 3,
        timeLimit: 60,
        steps: [],
        gameTypeData: {
          'items': [
            {'id': 'item1', 'label': 'Apple', 'isOdd': false},
            {'id': 'item2', 'label': 'Orange', 'isOdd': false},
            {'id': 'item3', 'label': 'Banana', 'isOdd': false},
            {'id': 'item4', 'label': 'Car', 'isOdd': true},
          ],
          'correctAnswer': 'item4',
        },
      );
    });

    test('should validate correct move', () {
      final isValid = engine.validateMove(
        puzzle: puzzle,
        moveData: {'selectedItemId': 'item4'},
        currentGameState: {'currentRound': 1},
      );

      expect(isValid, isTrue);
    });

    test('should process correct selection', () {
      final result = engine.processMove(
        puzzle: puzzle,
        moveData: {'itemId': 'item4', 'timeRemaining': 30},
        currentGameState: {'currentRound': 1, 'score': 0},
      );

      expect(result.isValid, true);
      expect(result.isCorrect, true);
      expect(result.score, greaterThan(0));
    });

    test('should process incorrect selection', () {
      final result = engine.processMove(
        puzzle: puzzle,
        moveData: {'itemId': 'item1', 'timeRemaining': 30},
        currentGameState: {'currentRound': 1, 'score': 0},
      );

      expect(result.isValid, true);
      expect(result.isCorrect, false);
    });

    test('should advance to next round on correct answer', () {
      final result = engine.processMove(
        puzzle: puzzle,
        moveData: {'itemId': 'item4', 'timeRemaining': 30},
        currentGameState: {'currentRound': 1, 'score': 0},
      );

      expect(result.updatedGameState?['currentRound'], 2);
    });

    test('should complete game after all rounds', () {
      final result = engine.processMove(
        puzzle: puzzle,
        moveData: {'itemId': 'item4', 'timeRemaining': 30},
        currentGameState: {'currentRound': 3, 'score': 0},
      );

      expect(result.isGameComplete, true);
    });
  });
}
