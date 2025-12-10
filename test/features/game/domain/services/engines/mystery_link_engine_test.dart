import 'package:flutter_test/flutter_test.dart';
import 'package:mystery_link/features/game/domain/services/engines/mystery_link_engine.dart';
import 'package:mystery_link/features/game/domain/entities/puzzle.dart';
import 'package:mystery_link/features/game/domain/entities/link_node.dart';
import 'package:mystery_link/features/game/domain/entities/puzzle_step.dart';
import 'package:mystery_link/features/game/domain/entities/game_type.dart';

void main() {
  group('MysteryLinkEngine', () {
    late MysteryLinkEngine engine;
    late Puzzle puzzle;

    setUp(() {
      engine = MysteryLinkEngine();
      puzzle = const Puzzle(
        id: 'test_puzzle',
        gameType: GameType.mysteryLink,
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
        steps: [
          PuzzleStep(
            order: 1,
            timeLimit: 12,
            options: [
              StepOption(
                node: LinkNode(
                  id: 'correct1',
                  label: 'Correct 1',
                  representationType: RepresentationType.text,
                ),
                isCorrect: true,
              ),
              StepOption(
                node: LinkNode(
                  id: 'wrong1',
                  label: 'Wrong 1',
                  representationType: RepresentationType.text,
                ),
                isCorrect: false,
              ),
            ],
          ),
          PuzzleStep(
            order: 2,
            timeLimit: 12,
            options: [
              StepOption(
                node: LinkNode(
                  id: 'correct2',
                  label: 'Correct 2',
                  representationType: RepresentationType.text,
                ),
                isCorrect: true,
              ),
              StepOption(
                node: LinkNode(
                  id: 'wrong2',
                  label: 'Wrong 2',
                  representationType: RepresentationType.text,
                ),
                isCorrect: false,
              ),
            ],
          ),
        ],
      );
    });

    test('should have correct game type', () {
      expect(engine.gameType, GameType.mysteryLink);
    });

    test('should validate correct move', () {
      final isValid = engine.validateMove(
        moveData: {
          'selectedNodeId': 'correct1',
          'stepOrder': 1,
        },
        puzzle: puzzle,
      );

      expect(isValid, true);
    });

    test('should validate incorrect move', () {
      final isValid = engine.validateMove(
        moveData: {
          'selectedNodeId': 'wrong1',
          'stepOrder': 1,
        },
        puzzle: puzzle,
      );

      expect(isValid, true); // Move is valid, but incorrect
    });

    test('should process correct move', () {
      final result = engine.processMove(
        moveData: {
          'selectedNodeId': 'correct1',
          'stepOrder': 1,
          'timeRemaining': 10,
        },
        puzzle: puzzle,
        currentStep: 1,
        currentScore: 0,
      );

      expect(result.isValid, true);
      expect(result.isCorrect, true);
      expect(result.score, greaterThan(0));
    });

    test('should process incorrect move', () {
      final result = engine.processMove(
        moveData: {
          'selectedNodeId': 'wrong1',
          'stepOrder': 1,
        },
        puzzle: puzzle,
        currentStep: 1,
        currentScore: 100,
      );

      expect(result.isValid, true);
      expect(result.isCorrect, false);
      expect(result.score, lessThan(0));
    });

    test('should check win condition', () {
      final isWin = engine.checkWinCondition(
        puzzle: puzzle,
        currentGameState: {'currentStep': 3}, // More than linksCount
        currentStep: 3,
      );

      expect(isWin, true);
    });

    test('should initialize game state', () {
      final gameState = engine.initializeGameState(puzzle);

      expect(gameState['currentStep'], 1);
      expect(gameState['chosenNodes'], isA<List>());
      expect(gameState['score'], 0);
    });
  });
}
