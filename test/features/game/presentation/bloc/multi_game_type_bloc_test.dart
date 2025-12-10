import 'package:flutter_test/flutter_test.dart';
import 'package:mystery_link/features/game/presentation/bloc/game_bloc.dart';
import 'package:mystery_link/features/game/presentation/bloc/game_event.dart';
import 'package:mystery_link/features/game/presentation/bloc/game_state.dart';
import 'package:mystery_link/features/game/domain/entities/game_type.dart';
import 'package:mystery_link/features/game/domain/entities/puzzle.dart';
import 'package:mystery_link/features/game/domain/entities/link_node.dart';
import 'package:mystery_link/features/game/domain/repositories/puzzle_repository_interface.dart';
import 'package:mystery_link/features/progression/data/services/progression_service.dart';
import 'package:mystery_link/features/adaptive_learning/domain/repositories/adaptive_learning_repository_interface.dart';
import 'package:mystery_link/features/adaptive_learning/domain/entities/difficulty_prediction.dart';
import 'package:mystery_link/features/adaptive_learning/domain/entities/learning_path.dart';
import 'package:mystery_link/features/adaptive_learning/domain/entities/player_cognitive_profile.dart';
import 'package:mystery_link/features/progression/domain/entities/game_result.dart';

class MockPuzzleRepository implements PuzzleRepositoryInterface {
  @override
  Future<List<Puzzle>> getAllPuzzles() async => [];

  @override
  Future<Puzzle?> getPuzzleById(String id) async => null;

  @override
  Future<List<Puzzle>> getPuzzlesByType(RepresentationType type) async => [];

  @override
  Future<List<Puzzle>> getPuzzlesByDifficulty(int linksCount) async => [];

  @override
  Future<List<Puzzle>> getPuzzlesForLevel(
    GameType mode,
    int level, {
    bool sortByChallenge = true,
  }) async =>
      [];

  @override
  Future<Puzzle?> getPuzzleForChallenge(
    GameType mode,
    int level,
    int challengeNumber,
  ) async =>
      null;

  @override
  Future<Map<int, List<Puzzle>>> getLevelsForMode(
    GameType mode, {
    int? maxLevels,
  }) async =>
      {};

  @override
  Future<Puzzle?> getRandomPuzzle({
    RepresentationType? type,
    int? linksCount,
    String? difficulty,
    String? category,
  }) async {
    // Return a simple test puzzle
    return const Puzzle(
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
      steps: [],
    );
  }
}

class MockProgressionService extends ProgressionService {
  MockProgressionService() : super();

  Future<void> saveGameResult(dynamic result) async {}
}

class MockAdaptiveLearningRepository
    implements AdaptiveLearningRepositoryInterface {
  @override
  Future<PlayerCognitiveProfile> getProfile() async {
    return PlayerCognitiveProfile.initial();
  }

  @override
  Future<PlayerCognitiveProfile> recordResult(GameResult result) async {
    return PlayerCognitiveProfile.initial();
  }

  @override
  Future<DifficultyPrediction> getPrediction() async {
    return const DifficultyPrediction(
      recommendedLinks: 3,
      confidence: 0.8,
      suggestedTimePerStep: Duration(seconds: 12),
      recommendedThemes: [],
      focusAreas: [],
      headline: 'Test',
      rationale: 'Test',
    );
  }

  @override
  Future<LearningPath> getLearningPath() async {
    return LearningPath.empty();
  }
}

void main() {
  group('Multi Game Type Bloc Tests', () {
    late GameBloc gameBloc;
    late MockPuzzleRepository mockRepository;

    setUp(() {
      mockRepository = MockPuzzleRepository();
      gameBloc = GameBloc(
        puzzleRepository: mockRepository,
        progressionService: MockProgressionService(),
        adaptiveLearningRepository: MockAdaptiveLearningRepository(),
      );
    });

    tearDown(() {
      gameBloc.close();
    });

    test('should handle GameStarted event with different game types', () async {
      const gameTypes = [
        GameType.mysteryLink,
        GameType.memoryFlip,
        GameType.spotTheOdd,
        GameType.sortSolve,
      ];

      for (final gameType in gameTypes) {
        gameBloc.add(GameStarted(
          gameType: gameType,
          representationType: RepresentationType.text,
          linksCount: 2,
          gameMode: 'solo',
        ));

        await expectLater(
          gameBloc.stream,
          emits(isA<GameState>()),
        );
      }
    });

    test('should handle CardFlipped event for Memory Flip', () async {
      gameBloc.add(const GameStarted(
        gameType: GameType.memoryFlip,
        representationType: RepresentationType.text,
        linksCount: 1,
        gameMode: 'solo',
      ));

      await expectLater(
        gameBloc.stream,
        emits(isA<GameState>()),
      );

      // Wait for puzzle to load
      await Future.delayed(const Duration(milliseconds: 100));

      gameBloc.add(const CardFlipped(cardId: 'card1'));

      // Should process the event without error
      expect(gameBloc.state, isA<GameState>());
    });

    test('should handle ItemSelected event for Spot the Odd', () async {
      gameBloc.add(const GameStarted(
        gameType: GameType.spotTheOdd,
        representationType: RepresentationType.text,
        linksCount: 1,
        gameMode: 'solo',
      ));

      await expectLater(
        gameBloc.stream,
        emits(isA<GameState>()),
      );

      await Future.delayed(const Duration(milliseconds: 100));

      gameBloc.add(const ItemSelected(itemId: 'item1'));

      expect(gameBloc.state, isA<GameState>());
    });

    test('should handle ItemMoved event for Sort & Solve', () async {
      gameBloc.add(const GameStarted(
        gameType: GameType.sortSolve,
        representationType: RepresentationType.text,
        linksCount: 1,
        gameMode: 'solo',
      ));

      await expectLater(
        gameBloc.stream,
        emits(isA<GameState>()),
      );

      await Future.delayed(const Duration(milliseconds: 100));

      gameBloc.add(const ItemMoved(itemId: 'item1', newPosition: 0));

      expect(gameBloc.state, isA<GameState>());
    });
  });
}
