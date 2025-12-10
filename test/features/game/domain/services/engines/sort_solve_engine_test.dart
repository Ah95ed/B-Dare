import 'package:flutter_test/flutter_test.dart';
import 'package:mystery_link/features/game/domain/services/engines/sort_solve_engine.dart';
import 'package:mystery_link/features/game/domain/entities/puzzle.dart';
import 'package:mystery_link/features/game/domain/entities/link_node.dart';
import 'package:mystery_link/features/game/domain/entities/game_type.dart';

void main() {
  group('SortSolveEngine', () {
    late SortSolveEngine engine;
    late Puzzle puzzle;

    setUp(() {
      engine = SortSolveEngine();
      puzzle = const Puzzle(
        id: 'test_puzzle',
        gameType: GameType.sortSolve,
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
        linksCount: 2,
        timeLimit: 60,
        steps: [],
        gameTypeData: {
          'items': [
            {'id': 'item1', 'label': 'Monday', 'order': 1},
            {'id': 'item2', 'label': 'Wednesday', 'order': 3},
            {'id': 'item3', 'label': 'Tuesday', 'order': 2},
            {'id': 'item4', 'label': 'Thursday', 'order': 4},
          ],
          'sortType': 'chronological',
        },
      );
    });

    test('should validate correct order', () {
      final isValid = engine.validateMove(
        puzzle: puzzle,
        moveData: {'itemId': 'item1', 'newPosition': 0},
        currentGameState: {'currentLevel': 1, 'currentOrder': []},
      );

      expect(isValid, isTrue);
    });

    test('should process correct arrangement', () {
      final result = engine.processMove(
        puzzle: puzzle,
        moveData: {
          'itemId': 'item1',
          'newPosition': 0,
          'timeRemaining': 30,
        },
        currentGameState: {
          'currentLevel': 1,
          'currentOrder': [],
          'score': 0,
        },
      );

      expect(result.isValid, true);
    });

    test('should check win condition', () {
      final result = engine.checkWinCondition(
        puzzle: puzzle,
        currentGameState: {
          'currentLevel': 2,
          'currentOrder': ['item1', 'item3', 'item2', 'item4'],
          'score': 100,
        },
      );

      expect(result, true);
    });
  });
}
