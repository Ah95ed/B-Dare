import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystery_link/features/game/domain/entities/link_node.dart';
import 'package:mystery_link/features/game/domain/entities/puzzle.dart';
import 'package:mystery_link/features/game/domain/entities/puzzle_step.dart';
import 'package:mystery_link/features/progression/domain/entities/progression_summary.dart';
import 'package:mystery_link/features/progression/domain/entities/player_progress.dart';
import 'package:mystery_link/features/progression/domain/entities/daily_challenge.dart';
import 'package:mystery_link/features/progression/domain/entities/game_result.dart';
import 'package:mystery_link/features/game/domain/repositories/puzzle_repository_interface.dart';
import 'package:mystery_link/features/game/presentation/bloc/game_bloc.dart';
import 'package:mystery_link/features/game/presentation/bloc/game_event.dart';
import 'package:mystery_link/features/game/presentation/bloc/game_state.dart';
import 'package:mystery_link/features/progression/data/services/progression_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mystery_link/features/adaptive_learning/domain/repositories/adaptive_learning_repository_interface.dart';
import 'package:mystery_link/features/adaptive_learning/domain/entities/player_cognitive_profile.dart';

class MockPuzzleRepository extends Mock implements PuzzleRepositoryInterface {}

class MockProgressionService extends Mock implements ProgressionService {}

class MockAdaptiveLearningRepository extends Mock
    implements AdaptiveLearningRepositoryInterface {}

class _FakeGameResult extends Fake implements GameResult {}

void main() {
  late MockPuzzleRepository mockRepository;
  late MockProgressionService mockProgressionService;
  late MockAdaptiveLearningRepository mockAdaptiveLearningRepository;
  late GameBloc gameBloc;
  final defaultSummary = ProgressionSummary(
    progress: PlayerProgress.initial(),
    xpEarned: 0,
    leveledUp: false,
    achievements: const [],
    newlyUnlocked: const [],
    dailyStatus: DailyChallengeStatus.initial(),
    newPhaseUnlocked: false,
    unlockedPhase: null,
  );

  setUpAll(() {
    registerFallbackValue(_FakeGameResult());
  });

  setUp(() {
    mockRepository = MockPuzzleRepository();
    mockProgressionService = MockProgressionService();
    mockAdaptiveLearningRepository = MockAdaptiveLearningRepository();
    gameBloc = GameBloc(
      puzzleRepository: mockRepository,
      progressionService: mockProgressionService,
      adaptiveLearningRepository: mockAdaptiveLearningRepository,
    );
    when(() => mockProgressionService.recordGameResult(any()))
        .thenAnswer((_) async => defaultSummary);
    when(() => mockAdaptiveLearningRepository.recordResult(any()))
        .thenAnswer((_) async => PlayerCognitiveProfile.initial());
    when(() => mockAdaptiveLearningRepository.getProfile())
        .thenAnswer((_) async => PlayerCognitiveProfile.initial());
  });

  tearDown(() {
    gameBloc.close();
  });

  group('GameBloc', () {
    const testPuzzle = Puzzle(
      id: 'test_puzzle',
      type: RepresentationType.text,
      start: LinkNode(
        id: 'start',
        label: 'Start',
        representationType: RepresentationType.text,
        labels: {'en': 'Start', 'ar': 'بداية'},
      ),
      end: LinkNode(
        id: 'end',
        label: 'End',
        representationType: RepresentationType.text,
        labels: {'en': 'End', 'ar': 'نهاية'},
      ),
      linksCount: 1,
      steps: [
        PuzzleStep(
          order: 1,
          timeLimit: 12,
          options: [
            StepOption(
              node: LinkNode(
                id: 'correct',
                label: 'Correct',
                representationType: RepresentationType.text,
                labels: {'en': 'Correct', 'ar': 'صحيح'},
              ),
              isCorrect: true,
            ),
            StepOption(
              node: LinkNode(
                id: 'wrong',
                label: 'Wrong',
                representationType: RepresentationType.text,
                labels: {'en': 'Wrong', 'ar': 'خطأ'},
              ),
              isCorrect: false,
            ),
          ],
        ),
      ],
      difficulty: 'easy',
      timeLimit: 30,
    );

    blocTest<GameBloc, GameState>(
      'shows notice when fallback criteria are used',
      setUp: () {
        when(() => mockRepository.getRandomPuzzle(
              type: RepresentationType.icon,
              linksCount: 1,
              difficulty: any(named: 'difficulty'),
              category: 'Science',
            )).thenAnswer((_) async => null);
        when(() => mockRepository.getRandomPuzzle(
              type: RepresentationType.icon,
              linksCount: 1,
              difficulty: any(named: 'difficulty'),
              category: null,
            )).thenAnswer((_) async => testPuzzle);
      },
      build: () => gameBloc,
      act: (bloc) => bloc.add(
        const GameStarted(
          representationType: RepresentationType.icon,
          linksCount: 1,
          gameMode: 'solo',
          category: 'Science',
        ),
      ),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const GameLoading(),
        isA<GameInProgress>()
            .having((state) => state.notice, 'notice', isNotNull),
      ],
    );

    test('initial state is GameInitial', () {
      expect(gameBloc.state, equals(const GameInitial()));
    });

    blocTest<GameBloc, GameState>(
      'emits [GameLoading, GameInProgress] when GameStarted is added with valid puzzle',
      setUp: () {
        when(() => mockRepository.getRandomPuzzle(
              type: any(named: 'type', that: isA<RepresentationType?>()),
              linksCount: any(named: 'linksCount', that: isA<int?>()),
              difficulty: any(named: 'difficulty', that: isA<String?>()),
              category: any(named: 'category', that: isA<String?>()),
            )).thenAnswer((_) async => testPuzzle);
      },
      build: () => gameBloc,
      act: (bloc) => bloc.add(
        const GameStarted(
          representationType: RepresentationType.text,
          linksCount: 1,
          gameMode: 'solo',
        ),
      ),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const GameLoading(),
        isA<GameInProgress>(),
      ],
    );

    blocTest<GameBloc, GameState>(
      'emits [GameLoading, GameErrorState] when puzzle is not found',
      setUp: () {
        when(() => mockRepository.getRandomPuzzle(
              type: any(named: 'type', that: isA<RepresentationType?>()),
              linksCount: any(named: 'linksCount', that: isA<int?>()),
              difficulty: any(named: 'difficulty', that: isA<String?>()),
              category: any(named: 'category', that: isA<String?>()),
            )).thenAnswer((_) async => null);
      },
      build: () => gameBloc,
      act: (bloc) => bloc.add(
        const GameStarted(
          representationType: RepresentationType.text,
          linksCount: 1,
          gameMode: 'solo',
        ),
      ),
      expect: () => [
        const GameLoading(),
        isA<GameErrorState>(),
      ],
    );

    blocTest<GameBloc, GameState>(
      'increments score when correct answer is selected',
      setUp: () {
        when(() => mockRepository.getRandomPuzzle(
              type: any(named: 'type', that: isA<RepresentationType?>()),
              linksCount: any(named: 'linksCount', that: isA<int?>()),
              difficulty: any(named: 'difficulty', that: isA<String?>()),
              category: any(named: 'category', that: isA<String?>()),
            )).thenAnswer((_) async => testPuzzle);
      },
      build: () => gameBloc,
      act: (bloc) {
        bloc.add(
          const GameStarted(
            representationType: RepresentationType.text,
            linksCount: 1,
            gameMode: 'solo',
          ),
        );
        // Wait for puzzle to load
        return Future.delayed(const Duration(milliseconds: 100), () {
          final correctNode = testPuzzle.steps[0].correctOption!.node;
          bloc.add(
            StepOptionSelected(
              stepOrder: 1,
              selectedNode: correctNode,
            ),
          );
        });
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        const GameLoading(),
        isA<GameInProgress>(),
        anyOf(isA<GameInProgress>(), isA<GameCompleted>()),
      ],
      verify: (bloc) {
        final state = bloc.state;
        if (state is GameInProgress) {
          expect(state.score, greaterThan(0));
          expect(state.chosenNodes.length, equals(1));
        } else if (state is GameCompleted) {
          expect(state.score, greaterThan(0));
          expect(state.chosenNodes.length, equals(1));
        }
      },
    );

    blocTest<GameBloc, GameState>(
      'emits GameCompleted when all steps are completed',
      setUp: () {
        when(() => mockRepository.getRandomPuzzle(
              type: any(named: 'type'),
              linksCount: any(named: 'linksCount'),
              category: any(named: 'category'),
            )).thenAnswer((_) async => testPuzzle);
        when(() => mockProgressionService.getProgress())
            .thenAnswer((_) async => PlayerProgress.initial());
        when(() => mockProgressionService.getDailyStatus())
            .thenAnswer((_) async => DailyChallengeStatus.initial());
        when(() => mockProgressionService.recordGameResult(
              any(),
            )).thenAnswer((_) async => ProgressionSummary(
              progress: PlayerProgress.initial(),
              xpEarned: 0,
              leveledUp: false,
              achievements: [],
              newlyUnlocked: [],
              dailyStatus: DailyChallengeStatus.initial(),
              newPhaseUnlocked: false,
              unlockedPhase: null,
            ));
      },
      build: () => gameBloc,
      act: (bloc) async {
        bloc.add(
          const GameStarted(
            representationType: RepresentationType.text,
            linksCount: 1,
            gameMode: 'solo',
          ),
        );
        await Future.delayed(const Duration(milliseconds: 100));
        final correctNode = testPuzzle.steps[0].correctOption!.node;
        bloc.add(
          StepOptionSelected(
            stepOrder: 1,
            selectedNode: correctNode,
          ),
        );
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(const GameFinished());
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        const GameLoading(),
        isA<GameInProgress>(),
        isA<GameCompleted>(),
      ],
    );

    blocTest<GameBloc, GameState>(
      'emits GameTimeOutState when timer expires',
      setUp: () {
        when(() => mockRepository.getRandomPuzzle(
              type: any(named: 'type'),
              linksCount: any(named: 'linksCount'),
              category: any(named: 'category'),
            )).thenAnswer((_) async => testPuzzle);
        when(() => mockProgressionService.getProgress())
            .thenAnswer((_) async => PlayerProgress.initial());
        when(() => mockProgressionService.getDailyStatus())
            .thenAnswer((_) async => DailyChallengeStatus.initial());
        when(() => mockProgressionService.recordGameResult(
              any(),
            )).thenAnswer((_) async => ProgressionSummary(
              progress: PlayerProgress.initial(),
              xpEarned: 0,
              leveledUp: false,
              achievements: [],
              newlyUnlocked: [],
              dailyStatus: DailyChallengeStatus.initial(),
              newPhaseUnlocked: false,
              unlockedPhase: null,
            ));
      },
      build: () => gameBloc,
      act: (bloc) {
        bloc.add(
          const GameStarted(
            representationType: RepresentationType.text,
            linksCount: 1,
            gameMode: 'solo',
          ),
        );
        return Future.delayed(const Duration(milliseconds: 100), () {
          bloc.add(const GameTimeOut());
        });
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        const GameLoading(),
        isA<GameInProgress>(),
        isA<GameTimeOutState>(),
      ],
    );

    blocTest<GameBloc, GameState>(
      'resets to GameInitial when GameReset is added',
      setUp: () {
        when(() => mockRepository.getRandomPuzzle(
              type: any(named: 'type', that: isA<RepresentationType?>()),
              linksCount: any(named: 'linksCount', that: isA<int?>()),
              difficulty: any(named: 'difficulty', that: isA<String?>()),
              category: any(named: 'category', that: isA<String?>()),
            )).thenAnswer((_) async => testPuzzle);
      },
      build: () => gameBloc,
      seed: () => const GameInProgress(
        puzzle: testPuzzle,
        currentStep: 1,
        chosenNodes: [],
        score: 100,
        remainingSeconds: 20,
      ),
      act: (bloc) => bloc.add(const GameReset()),
      expect: () => [
        const GameInitial(),
      ],
    );
  });
}
