import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/puzzle_repository_interface.dart';
import '../../domain/entities/puzzle.dart';
import '../../domain/entities/link_node.dart';
import '../../domain/entities/puzzle_step.dart';
import '../../domain/entities/game_type.dart';
import '../../domain/services/puzzle_selection_service.dart';
import '../../domain/services/game_engine_factory.dart';
import '../../domain/services/game_engine_interface.dart';
import 'base_game_bloc.dart';
import 'game_event.dart';
import 'game_state.dart';
import '../../../../core/constants/game_constants.dart';
import '../../../progression/data/services/progression_service.dart';
import '../../../progression/domain/entities/game_result.dart';
import '../../../adaptive_learning/domain/repositories/adaptive_learning_repository_interface.dart';

class GameBloc extends BaseGameBloc {
  final PuzzleRepositoryInterface puzzleRepository;
  final ProgressionService progressionService;
  final PuzzleSelectionService _puzzleSelection;
  final AdaptiveLearningRepositoryInterface _adaptiveLearningRepository;
  final GameEngineFactory _engineFactory = GameEngineFactory();
  Timer? _timer;
  String? _activeGameMode;
  final Set<int> _hintedSteps = <int>{};
  Map<String, dynamic>? _currentGameState; // حالة اللعبة الخاصة بالنمط

  GameBloc({
    required this.puzzleRepository,
    required this.progressionService,
    required AdaptiveLearningRepositoryInterface adaptiveLearningRepository,
    Map<String, List<String>> phasePacks = const {},
  })  : _puzzleSelection = PuzzleSelectionService(
          puzzleRepository,
          progressionService: progressionService,
          phaseCulturePacks: phasePacks,
        ),
        _adaptiveLearningRepository = adaptiveLearningRepository,
        super() {
    on<GameStarted>(_onGameStarted);
    on<PuzzleLoaded>(_onPuzzleLoaded);
    on<StepOptionSelected>(_onStepOptionSelected);
    on<CardFlipped>(_onCardFlipped);
    on<ItemSelected>(_onItemSelected);
    on<ItemMoved>(_onItemMoved);
    on<TileArranged>(_onTileArranged);
    on<TimerTicked>(_onTimerTicked);
    on<GameTimeOut>(_onGameTimeOut);
    on<GameFinished>(_onGameFinished);
    on<GameReset>(_onGameReset);
    on<GameError>(_onGameError);
    on<HintUsed>(_onHintUsed);
  }

  Future<void> _onGameStarted(
    GameStarted event,
    Emitter<GameState> emit,
  ) async {
    emit(const GameLoading());
    _activeGameMode = event.gameMode;
    _hintedSteps.clear();

    try {
      Puzzle? puzzle;
      String? notice;

      // Check if custom puzzle is provided
      if (event.customPuzzle != null) {
        // Import CustomPuzzle here to avoid circular dependency
        try {
          final customPuzzleData = event.customPuzzle!;
          puzzle = _createPuzzleFromCustom(customPuzzleData);
        } catch (e) {
          emit(GameErrorState('Failed to load custom puzzle: $e'));
          return;
        }
      } else {
        final selection = await _puzzleSelection.resolve(
          requestedType: event.representationType,
          requestedLinks: event.linksCount,
          requestedCategory: event.category,
        );
        puzzle = selection.puzzle;
        notice = selection.notice;

        if (puzzle == null) {
          emit(const GameErrorState(
              'No puzzle found with the selected criteria'));
          return;
        }
      }

      add(PuzzleLoaded(puzzle, notice: notice));
    } catch (e) {
      emit(GameErrorState('Failed to load puzzle: $e'));
    }
  }

  Puzzle _createPuzzleFromCustom(Map<String, dynamic> customPuzzleData) {
    // This is a simplified version - in real implementation, use CustomPuzzle.fromJson
    // For now, we'll create Puzzle directly from the data
    return Puzzle(
      id: customPuzzleData['id'] ?? 'custom_puzzle',
      type: _parseRepresentationType(customPuzzleData['type']),
      start: _createLinkNodeFromJson(customPuzzleData['start']),
      end: _createLinkNodeFromJson(customPuzzleData['end']),
      linksCount: (customPuzzleData['steps'] as List).length,
      steps: (customPuzzleData['steps'] as List).map((stepData) {
        return PuzzleStep(
          order: stepData['order'],
          timeLimit: stepData['timeLimit'] ?? 12,
          options: (stepData['options'] as List).map((optionData) {
            return StepOption(
              node: _createLinkNodeFromJson(optionData['node']),
              isCorrect: optionData['isCorrect'] ?? false,
            );
          }).toList(),
        );
      }).toList(),
      difficulty: 'custom',
      timeLimit: customPuzzleData['timeLimit'] ?? 12,
    );
  }

  LinkNode _createLinkNodeFromJson(Map<String, dynamic> nodeData) {
    return LinkNode(
      id: nodeData['id'] ?? '',
      label: nodeData['label'] ?? '',
      representationType:
          _parseRepresentationType(nodeData['representationType']),
      labels: Map<String, String>.from(nodeData['labels'] ?? {}),
    );
  }

  RepresentationType _parseRepresentationType(String? type) {
    if (type == null) return RepresentationType.text;
    final typeStr = type.replaceAll('RepresentationType.', '');
    return RepresentationType.values.firstWhere(
      (e) => e.toString().contains(typeStr),
      orElse: () => RepresentationType.text,
    );
  }

  void _onPuzzleLoaded(
    PuzzleLoaded event,
    Emitter<GameState> emit,
  ) {
    final puzzle = event.puzzle;
    if (puzzle == null) {
      emit(const GameErrorState('Failed to load puzzle.'));
      return;
    }
    final totalTime = puzzle.timeLimit;

    // تهيئة gameState من Engine
    final engine = _engineFactory.getEngine(puzzle.gameType);
    _currentGameState = engine.initializeGameState(puzzle);

    emit(GameInProgress(
      puzzle: puzzle,
      gameType: puzzle.gameType,
      currentStep: 1,
      chosenNodes: const [],
      score: 0,
      remainingSeconds: totalTime,
      startTime: DateTime.now(),
      notice: event.notice,
      gameSpecificData: _currentGameState,
    ));

    _startTimer(totalTime);
  }

  Future<void> _onStepOptionSelected(
    StepOptionSelected event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameInProgress) return;

    final currentState = state as GameInProgress;
    final puzzle = currentState.puzzle;
    final engine = _engineFactory.getEngine(puzzle.gameType);

    // استخدام Engine لمعالجة الحركة
    final moveData = {
      'selectedNodeId': event.selectedNode.id,
      'stepOrder': event.stepOrder,
      'timeRemaining': currentState.remainingSeconds,
      ...?event.gameSpecificData,
    };

    final result = engine.processMove(
      moveData: moveData,
      puzzle: puzzle,
      currentGameState: _currentGameState,
      currentStep: currentState.currentStep,
      currentScore: currentState.score,
    );

    if (!result.isValid) {
      // خطأ في الحركة
      return;
    }

    // تحديث _currentGameState
    _currentGameState = result.updatedGameState ?? _currentGameState;

    // للـ Mystery Link، نستخدم المنطق القديم
    if (puzzle.gameType == GameType.mysteryLink) {
      await _handleMysteryLinkMove(currentState, event, result, emit);
    } else {
      await _handleGenericMove(currentState, result, emit);
    }
  }

  Future<void> _handleMysteryLinkMove(
    GameInProgress currentState,
    StepOptionSelected event,
    MoveResult result,
    Emitter<GameState> emit,
  ) async {
    final puzzle = currentState.puzzle;
    final currentStep = currentState.currentStep;
    final step = puzzle.steps[currentStep - 1];
    final correctOption = step.correctOption;

    if (correctOption == null) return;

    final isCorrect = correctOption.node.id == event.selectedNode.id;

    if (isCorrect) {
      final newChosenNodes = [...currentState.chosenNodes, event.selectedNode];
      const timeBonusThreshold = GameConstants.timeBonusThreshold;
      const bonusMultiplier = GameConstants.bonusMultiplier;
      final timeBonus = currentState.remainingSeconds > timeBonusThreshold
          ? bonusMultiplier
          : 1;
      var stepScore =
          GameConstants.basePointsPerStep * puzzle.linksCount * timeBonus;
      if (_hintedSteps.contains(currentStep)) {
        stepScore = (stepScore * GameConstants.hintPenaltyMultiplier).round();
      }
      final newScore = currentState.score + stepScore;

      if (currentStep >= puzzle.linksCount) {
        _timer?.cancel();
        final completionTime = DateTime.now();
        final timeSpent = currentState.startTime != null
            ? completionTime.difference(currentState.startTime!)
            : const Duration(seconds: 0);

        final isPerfect = newChosenNodes.length == puzzle.linksCount;
        final result = GameResult(
          puzzle: puzzle,
          score: newScore,
          timeSpent: timeSpent,
          isPerfect: isPerfect,
          isDaily: _isDailyMode,
          isWin: true,
          completedAt: completionTime,
        );
        final progression = await progressionService.recordGameResult(result);
        await _adaptiveLearningRepository.recordResult(result);

        emit(GameCompleted(
          puzzle: puzzle,
          chosenNodes: newChosenNodes,
          score: newScore,
          timeSpent: timeSpent,
          isPerfect: isPerfect,
          progression: progression,
        ));
      } else {
        emit(currentState.copyWith(
          currentStep: currentStep + 1,
          chosenNodes: newChosenNodes,
          score: newScore,
        ));
      }
    } else {
      // Wrong answer - deduct points but allow continuation
      const penalty = GameConstants.basePointsPerStep ~/ 2;
      final newScore =
          (currentState.score - penalty).clamp(0, double.infinity).toInt();

      emit(currentState.copyWith(score: newScore));
    }
  }

  Future<void> _handleGenericMove(
    GameInProgress currentState,
    MoveResult result,
    Emitter<GameState> emit,
  ) async {
    final puzzle = currentState.puzzle;
    final newScore = currentState.score + (result.score ?? 0);

    if (result.isGameComplete) {
      _timer?.cancel();
      final completionTime = DateTime.now();
      final timeSpent = currentState.startTime != null
          ? completionTime.difference(currentState.startTime!)
          : const Duration(seconds: 0);

      final resultEntity = GameResult(
        puzzle: puzzle,
        score: newScore,
        timeSpent: timeSpent,
        isPerfect: result.isCorrect,
        isDaily: _isDailyMode,
        isWin: result.isCorrect,
        completedAt: completionTime,
      );
      final progression = await progressionService.recordGameResult(resultEntity);
      await _adaptiveLearningRepository.recordResult(resultEntity);

      emit(GameCompleted(
        puzzle: puzzle,
        chosenNodes: currentState.chosenNodes,
        score: newScore,
        timeSpent: timeSpent,
        isPerfect: result.isCorrect,
        progression: progression,
      ));
    } else {
      emit(currentState.copyWith(
        score: newScore,
        gameSpecificData: _currentGameState,
      ));
    }
  }

  Future<void> _onCardFlipped(
    CardFlipped event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameInProgress) return;

    final currentState = state as GameInProgress;
    final puzzle = currentState.puzzle;
    final engine = _engineFactory.getEngine(puzzle.gameType);

    final moveData = {
      'cardId': event.cardId,
      'timeRemaining': currentState.remainingSeconds,
      ...?event.gameSpecificData,
    };

    final result = engine.processMove(
      moveData: moveData,
      puzzle: puzzle,
      currentGameState: _currentGameState,
      currentStep: currentState.currentStep,
      currentScore: currentState.score,
    );

    if (!result.isValid) return;

    _currentGameState = result.updatedGameState ?? _currentGameState;
    await _handleGenericMove(currentState, result, emit);
  }

  Future<void> _onItemSelected(
    ItemSelected event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameInProgress) return;

    final currentState = state as GameInProgress;
    final puzzle = currentState.puzzle;
    final engine = _engineFactory.getEngine(puzzle.gameType);

    final moveData = {
      'selectedItemId': event.itemId,
      'timeRemaining': currentState.remainingSeconds,
      ...?event.gameSpecificData,
    };

    final result = engine.processMove(
      moveData: moveData,
      puzzle: puzzle,
      currentGameState: _currentGameState,
      currentStep: currentState.currentStep,
      currentScore: currentState.score,
    );

    if (!result.isValid) return;

    _currentGameState = result.updatedGameState ?? _currentGameState;
    await _handleGenericMove(currentState, result, emit);
  }

  Future<void> _onItemMoved(
    ItemMoved event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameInProgress) return;

    final currentState = state as GameInProgress;
    final puzzle = currentState.puzzle;
    final engine = _engineFactory.getEngine(puzzle.gameType);

    final moveData = {
      'itemId': event.itemId,
      'newPosition': event.newPosition,
      'timeRemaining': currentState.remainingSeconds,
      ...?event.gameSpecificData,
    };

    final result = engine.processMove(
      moveData: moveData,
      puzzle: puzzle,
      currentGameState: _currentGameState,
      currentStep: currentState.currentStep,
      currentScore: currentState.score,
    );

    if (!result.isValid) return;

    _currentGameState = result.updatedGameState ?? _currentGameState;
    await _handleGenericMove(currentState, result, emit);
  }

  Future<void> _onTileArranged(
    TileArranged event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameInProgress) return;

    final currentState = state as GameInProgress;
    final puzzle = currentState.puzzle;
    final engine = _engineFactory.getEngine(puzzle.gameType);

    final moveData = {
      'tileId': event.tileId,
      'newPosition': event.newPosition,
      'timeRemaining': currentState.remainingSeconds,
      ...?event.gameSpecificData,
    };

    final result = engine.processMove(
      moveData: moveData,
      puzzle: puzzle,
      currentGameState: _currentGameState,
      currentStep: currentState.currentStep,
      currentScore: currentState.score,
    );

    if (!result.isValid) return;

    _currentGameState = result.updatedGameState ?? _currentGameState;
    await _handleGenericMove(currentState, result, emit);
  }

  void _onTimerTicked(
    TimerTicked event,
    Emitter<GameState> emit,
  ) {
    if (state is! GameInProgress) return;

    final currentState = state as GameInProgress;

    if (event.remainingSeconds <= 0) {
      add(const GameTimeOut());
      return;
    }

    emit(currentState.copyWith(remainingSeconds: event.remainingSeconds));
  }

  Future<void> _onGameTimeOut(
    GameTimeOut event,
    Emitter<GameState> emit,
  ) async {
    _timer?.cancel();

    if (state is! GameInProgress) return;

    final currentState = state as GameInProgress;
    final completionTime = DateTime.now();
    final timeSpent = currentState.startTime != null
        ? completionTime.difference(currentState.startTime!)
        : const Duration(seconds: 0);
    final result = GameResult(
      puzzle: currentState.puzzle,
      score: currentState.score,
      timeSpent: timeSpent,
      isPerfect: false,
      isDaily: _isDailyMode,
      isWin: false,
      completedAt: completionTime,
    );
    final progression = await progressionService.recordGameResult(result);
    await _adaptiveLearningRepository.recordResult(result);
    emit(GameTimeOutState(
      puzzle: currentState.puzzle,
      chosenNodes: currentState.chosenNodes,
      score: currentState.score,
      progression: progression,
    ));
  }

  void _onGameFinished(
    GameFinished event,
    Emitter<GameState> emit,
  ) {
    _timer?.cancel();
    // This is handled in StepOptionSelected when completing all steps
  }

  void _onGameReset(
    GameReset event,
    Emitter<GameState> emit,
  ) {
    _currentGameState = null;
    _timer?.cancel();
    _activeGameMode = null;
    _hintedSteps.clear();
    emit(const GameInitial());
  }

  void _onGameError(
    GameError event,
    Emitter<GameState> emit,
  ) {
    _timer?.cancel();
    _activeGameMode = null;
    emit(GameErrorState(event.message));
  }

  void _onHintUsed(
    HintUsed event,
    Emitter<GameState> emit,
  ) {
    if (_activeGameMode != 'guided') {
      return;
    }
    _hintedSteps.add(event.stepOrder);
    if (kDebugMode) {
      debugPrint('Hint registered for step ${event.stepOrder}');
    }
  }

  bool get _isDailyMode => _activeGameMode == 'daily';

  void _startTimer(int totalSeconds) {
    _timer?.cancel();
    int remaining = totalSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining--;
      add(TimerTicked(remaining));

      if (remaining <= 0) {
        timer.cancel();
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
