import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import '../../domain/repositories/puzzle_repository_interface.dart';
import '../../domain/services/puzzle_selection_service.dart';
import '../../domain/services/game_engine_factory.dart';
import '../../domain/services/game_engine_interface.dart';
import '../../domain/entities/game_type.dart';
import '../../../progression/data/services/progression_service.dart';
import '../../../progression/domain/entities/game_result.dart';
import '../../../../core/constants/game_constants.dart';
import '../../../adaptive_learning/domain/repositories/adaptive_learning_repository_interface.dart';
import '../../../group/data/services/family_session_tracker.dart';
import '../../../group/data/services/family_session_storage.dart';
import '../../../group/domain/entities/family_session_stats.dart';
import '../../../multiplayer/data/services/cloudflare_multiplayer_service.dart';
import 'base_game_bloc.dart';
import 'game_event.dart';
import 'game_state.dart';
import '../../domain/entities/puzzle.dart';
import '../../domain/entities/link_node.dart';
import '../../domain/entities/puzzle_step.dart';
import '../../data/models/puzzle_model.dart';

class Player {
  final int id;
  final String name;
  int score;

  // إحصائيات المنافسة
  int correctAnswers; // عدد الإجابات الصحيحة
  int wrongAnswers; // عدد الإجابات الخاطئة
  Duration totalTimeSpent; // إجمالي الوقت المستغرق في الإجابات
  List<Duration> answerTimes; // أوقات الإجابة لكل خطوة (لحساب المتوسط)
  DateTime? currentStepStartTime; // وقت بداية الخطوة الحالية

  Player({
    required this.id,
    required this.name,
    this.score = 0,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
    this.totalTimeSpent = const Duration(seconds: 0),
    List<Duration>? answerTimes,
  }) : answerTimes = answerTimes ?? [];

  // متوسط وقت الإجابة (بالثواني)
  double get averageAnswerTime {
    if (answerTimes.isEmpty) return 0.0;
    final totalSeconds = answerTimes.fold<int>(
      0,
      (sum, duration) => sum + duration.inSeconds,
    );
    return totalSeconds / answerTimes.length;
  }

  // معدل الدقة (نسبة الإجابات الصحيحة)
  double get accuracyRate {
    final totalAnswers = correctAnswers + wrongAnswers;
    if (totalAnswers == 0) return 0.0;
    return (correctAnswers / totalAnswers) * 100;
  }

  // سرعة الإجابة (نقاط لكل ثانية)
  double get speedScore {
    if (totalTimeSpent.inSeconds == 0) return 0.0;
    return score / totalTimeSpent.inSeconds;
  }

  Player copyWith({
    int? score,
    int? correctAnswers,
    int? wrongAnswers,
    Duration? totalTimeSpent,
    List<Duration>? answerTimes,
    DateTime? currentStepStartTime,
  }) {
    return Player(
      id: id,
      name: name,
      score: score ?? this.score,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
      answerTimes: answerTimes ?? this.answerTimes,
    )..currentStepStartTime = currentStepStartTime ?? this.currentStepStartTime;
  }
}

class GroupGameState {
  final List<Player> players;
  final int currentPlayerIndex;
  final bool isGameOver;

  GroupGameState({
    required this.players,
    this.currentPlayerIndex = 0,
    this.isGameOver = false,
  });

  Player get currentPlayer => players[currentPlayerIndex];

  GroupGameState copyWith({
    List<Player>? players,
    int? currentPlayerIndex,
    bool? isGameOver,
  }) {
    return GroupGameState(
      players: players ?? this.players,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }
}

class GroupGameBloc extends BaseGameBloc {
  final PuzzleRepositoryInterface puzzleRepository;
  final ProgressionService progressionService;
  final PuzzleSelectionService _puzzleSelection;
  final AdaptiveLearningRepositoryInterface _adaptiveLearningRepository;
  final FamilySessionTracker _familySessionTracker = FamilySessionTracker();
  final GameEngineFactory _engineFactory = GameEngineFactory();
  String? _currentGroupProfile;
  final FamilySessionStorage _familySessionStorage;
  GroupGameState? groupState;
  final int playersCount;
  Timer? _timer;
  Map<String, dynamic>? _currentGameState; // حالة اللعبة الخاصة بالنمط

  // Multiplayer support
  final CloudflareMultiplayerService? _multiplayerService;
  StreamSubscription<MultiplayerMessage>? _multiplayerSubscription;

  bool get isMultiplayerMode =>
      _multiplayerService != null && _multiplayerService!.isConnected;

  GroupGameBloc({
    required this.puzzleRepository,
    required this.progressionService,
    required this.playersCount,
    required AdaptiveLearningRepositoryInterface adaptiveLearningRepository,
    required FamilySessionStorage familySessionStorage,
    CloudflareMultiplayerService? multiplayerService,
    Map<String, List<String>> phasePacks = const {},
  })  : _puzzleSelection = PuzzleSelectionService(
          puzzleRepository,
          progressionService: progressionService,
          phaseCulturePacks: phasePacks,
        ),
        _familySessionStorage = familySessionStorage,
        _adaptiveLearningRepository = adaptiveLearningRepository,
        _multiplayerService = multiplayerService,
        super() {
    groupState = GroupGameState(
      players: List<Player>.generate(
        playersCount,
        (index) => Player(
          id: index,
          name: 'Player ${index + 1}',
          score: 0,
          correctAnswers: 0,
          wrongAnswers: 0,
          totalTimeSpent: const Duration(seconds: 0),
          answerTimes: [],
        ),
      ),
    );

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

    // إعداد Multiplayer إذا كان متاحاً
    if (_multiplayerService != null) {
      _setupMultiplayer();
    }
  }

  void _setupMultiplayer() {
    _multiplayerSubscription = _multiplayerService!.messageStream.listen(
      (message) {
        _handleMultiplayerMessage(message);
      },
      onError: (error) {
        debugPrint('Multiplayer error: $error');
      },
    );
  }

  void _handleMultiplayerMessage(MultiplayerMessage message) {
    if (message.isGameStarted) {
      // اللعبة بدأت من الخادم - مزامنة الحالة
      // الخادم يرسل gameState داخل data
      final gameStateData =
          message.data['gameState'] as Map<String, dynamic>? ?? message.data;
      _syncStateFromCloudflare(gameStateData);
    } else if (message.isStepCompleted) {
      // خطوة اكتملت - تحديث الحالة المحلية
      // سيتم تحديثها تلقائياً من الخادم في gameState
    } else if (message.type == 'gameState') {
      // تحديث كامل للحالة من الخادم
      _syncStateFromCloudflare(message.data);
    } else if (message.isWrongAnswer) {
      // إجابة خاطئة - لا حاجة لإجراء خاص، الحالة محدثة من الخادم
      debugPrint('Wrong answer from server');
    } else if (message.isGameCompleted) {
      // اللعبة انتهت - الانتقال إلى Result Screen
      // سيتم الانتقال تلقائياً عند استقبال gameCompleted
      debugPrint('Game completed from server');
    } else if (message.isGameTimeout) {
      // انتهى الوقت
      add(const GameTimeOut());
    } else if (message.isPlayerJoined) {
      // لاعب جديد انضم
      final playerData = message.data['player'] as Map<String, dynamic>?;
      if (playerData != null) {
        debugPrint('Player joined: ${playerData['name']}');
        // يمكن إضافة لاعب جديد إلى groupState إذا لزم
      }
    } else if (message.isPlayerLeft) {
      // لاعب غادر
      final playerId = message.data['playerId'] as String?;
      debugPrint('Player left: $playerId');
      // يمكن إزالة لاعب من groupState إذا لزم
    } else if (message.isTimerTick) {
      // تحديث المؤقت
      final remainingSeconds = message.data['remainingSeconds'] as int?;
      if (remainingSeconds != null) {
        add(TimerTicked(remainingSeconds));
      }
    } else if (message.isError) {
      // خطأ
      final errorMessage =
          message.data['message'] as String? ?? 'Unknown error';
      debugPrint('Multiplayer error: $errorMessage');
      // يمكن إضافة error state إذا لزم
    } else if (message.isConnected) {
      // اتصال ناجح
      debugPrint('Connected to Cloudflare room');
      // طلب الحالة الحالية
      _multiplayerService?.requestGameState();
    }
  }

  void _syncStateFromCloudflare(Map<String, dynamic> gameStateData) {
    // مزامنة الحالة من الخادم
    // هذا يتم استدعاؤه عند استقبال gameState أو gameStarted

    final remainingSeconds = gameStateData['remainingSeconds'] as int?;
    final isGameOver = gameStateData['isGameOver'] as bool? ?? false;
    final gameSpecificData =
        gameStateData['gameSpecificData'] as Map<String, dynamic>?;
    final puzzleData = gameStateData['puzzle'] as Map<String, dynamic>?;
    final gameTypeStr = gameStateData['gameType'] as String?;

    // إذا كان هناك puzzle data، نحتاج لإنشاء GameInProgress
    if (puzzleData != null && state is! GameInProgress) {
      try {
        final puzzle = PuzzleModel.fromJson(puzzleData);
        final gameType = gameTypeStr != null
            ? const GameTypeConverter().fromJson(gameTypeStr)
            : puzzle.gameType;

        // تهيئة gameState من Engine
        final engine = _engineFactory.getEngine(gameType);
        _currentGameState =
            gameSpecificData ?? engine.initializeGameState(puzzle);

        // إنشاء GameInProgress state
        add(PuzzleLoaded(puzzle));

        // الانتظار قليلاً ثم تحديث الحالة
        Future.delayed(const Duration(milliseconds: 100), () {
          if (state is GameInProgress) {
            // الحالة تم إنشاؤها بالفعل من PuzzleLoaded
            // فقط نحدث المؤقت
            if (remainingSeconds != null) {
              add(TimerTicked(remainingSeconds));
            }
          }
        });

        return;
      } catch (e) {
        debugPrint('Error parsing puzzle from Cloudflare: $e');
        // نتابع مع التحديثات العادية
      }
    }

    if (gameSpecificData != null) {
      _currentGameState = gameSpecificData;
    }

    // تحديث المؤقت إذا كان متوفراً
    if (remainingSeconds != null) {
      add(TimerTicked(remainingSeconds));
    }

    // إذا انتهت اللعبة، الانتقال إلى النتيجة
    if (isGameOver && state is GameInProgress) {
      add(const GameFinished());
    }
  }

  Future<void> _onGameStarted(
    GameStarted event,
    Emitter<GameState> emit,
  ) async {
    emit(const GameLoading());
    _currentGroupProfile = event.groupProfile;
    final storedStats =
        await _familySessionStorage.loadStats(_currentGroupProfile);
    _familySessionTracker.hydrate(storedStats);
    _familySessionTracker.startSession(_currentGroupProfile);

    // تحديث اللاعبين من customPlayers إذا كان متوفراً
    if (event.customPlayers != null && event.customPlayers!.isNotEmpty) {
      final customPlayers = event.customPlayers!;
      groupState = GroupGameState(
        players: customPlayers.asMap().entries.map((entry) {
          final index = entry.key;
          final playerData = entry.value;
          return Player(
            id: int.tryParse(
                    playerData['id']?.toString() ?? index.toString()) ??
                index,
            name: playerData['name']?.toString() ?? 'Player ${index + 1}',
            score: 0,
            correctAnswers: 0,
            wrongAnswers: 0,
            totalTimeSpent: const Duration(seconds: 0),
            answerTimes: [],
          );
        }).toList(),
      );
    }

    try {
      Puzzle? puzzle;
      String? notice;

      // Check if custom puzzle is provided
      if (event.customPuzzle != null) {
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
      }

      if (puzzle == null) {
        emit(
            const GameErrorState('No puzzle found with the selected criteria'));
        return;
      }

      // إذا كان في وضع multiplayer وكان المضيف، أرسل للخادم
      if (_multiplayerService != null && _multiplayerService!.isConnected) {
        final isHost = groupState?.players
                .firstWhere(
                  (p) => p.id == 0,
                  orElse: () => groupState!.players.first,
                )
                .id ==
            0;

        if (isHost) {
          await _multiplayerService!.startGame(
            representationType: event.representationType.name,
            linksCount: event.linksCount,
            category: event.category,
            puzzle: puzzle,
          );
        }
      }

      add(PuzzleLoaded(puzzle, notice: notice));
    } catch (e) {
      emit(GameErrorState('Failed to load puzzle: $e'));
    }
  }

  void _startTimer(int totalSeconds) {
    _timer?.cancel();
    var remaining = totalSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining--;
      add(TimerTicked(remaining));
      if (remaining <= 0) {
        timer.cancel();
      }
    });
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

    // تهيئة وقت بداية الخطوة للاعب الحالي
    if (groupState != null) {
      final currentPlayer = groupState!.currentPlayer;
      final updatedPlayers = groupState!.players.map((player) {
        if (player.id == currentPlayer.id) {
          return player.copyWith(
            currentStepStartTime: DateTime.now(),
          );
        }
        return player;
      }).toList();
      groupState = groupState!.copyWith(players: updatedPlayers);
    }

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

  void _onStepOptionSelected(
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
      return;
    }

    _currentGameState = result.updatedGameState ?? _currentGameState;

    // للـ Mystery Link، نستخدم المنطق القديم
    if (puzzle.gameType == GameType.mysteryLink) {
      await _handleMysteryLinkMoveGroup(currentState, event, result, emit);
    } else {
      await _handleGenericMoveGroup(currentState, result, emit);
    }
  }

  Future<void> _handleMysteryLinkMoveGroup(
    GameInProgress currentState,
    StepOptionSelected event,
    MoveResult result,
    Emitter<GameState> emit,
  ) async {
    final puzzle = currentState.puzzle;
    final currentStep = currentState.currentStep;

    if (currentStep > puzzle.linksCount) return;

    final step = puzzle.steps[currentStep - 1];
    final correctOption = step.correctOption;

    if (correctOption == null) return;

    final isCorrect = correctOption.node.id == event.selectedNode.id;
    final answerTime = DateTime.now();

    // إرسال للخادم إذا كان في وضع multiplayer
    if (_multiplayerService != null && _multiplayerService!.isConnected) {
      try {
        await _multiplayerService!.selectOption(
          selectedNode: event.selectedNode,
          stepOrder: currentStep,
        );
        // في وضع multiplayer، ننتظر التحديث من الخادم
        // لذلك لا نحدث الحالة المحلية هنا
        return;
      } catch (e) {
        debugPrint('Error sending to multiplayer server: $e');
        // في حالة الخطأ، نتابع المعالجة المحلية
      }
    }

    // حساب وقت الإجابة للاعب الحالي
    Duration? stepAnswerTime;
    if (groupState != null) {
      final currentPlayer = groupState!.currentPlayer;
      if (currentPlayer.currentStepStartTime != null) {
        stepAnswerTime =
            answerTime.difference(currentPlayer.currentStepStartTime!);
      }
    }

    if (isCorrect) {
      final newChosenNodes = [...currentState.chosenNodes, event.selectedNode];

      // حساب النقاط بناءً على سرعة الإجابة
      int timeBonus = 1;
      if (currentState.remainingSeconds > GameConstants.timeBonusThreshold) {
        timeBonus = GameConstants.bonusMultiplier;
      }

      // مكافأة إضافية للسرعة (إذا أجاب في أقل من 5 ثواني)
      if (stepAnswerTime != null && stepAnswerTime.inSeconds < 5) {
        timeBonus = (timeBonus * 1.5).round();
      }

      final stepScore =
          GameConstants.basePointsPerStep * puzzle.linksCount * timeBonus;
      final newScore = currentState.score + stepScore;

      // تحديث إحصائيات اللاعب
      if (groupState != null && stepAnswerTime != null) {
        final currentPlayer = groupState!.currentPlayer;
        final updatedAnswerTimes = [
          ...currentPlayer.answerTimes,
          stepAnswerTime
        ];
        final updatedPlayers = groupState!.players.map((player) {
          if (player.id == currentPlayer.id) {
            return player.copyWith(
              score: player.score + stepScore,
              correctAnswers: player.correctAnswers + 1,
              totalTimeSpent: player.totalTimeSpent + stepAnswerTime!,
              answerTimes: updatedAnswerTimes,
              currentStepStartTime: null, // إعادة تعيين للخطوة التالية
            );
          }
          return player;
        }).toList();
        groupState = groupState!.copyWith(players: updatedPlayers);
      }

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
          isDaily: false,
          isWin: true,
          completedAt: completionTime,
        );
        final progression = await progressionService.recordGameResult(result);
        await _adaptiveLearningRepository.recordResult(result);
        await _completeFamilySession(isWin: true);
        _advancePlayer();
        emit(GameCompleted(
          puzzle: puzzle,
          chosenNodes: newChosenNodes,
          score: newScore,
          timeSpent: timeSpent,
          isPerfect: isPerfect,
          progression: progression,
        ));
      } else {
        _advancePlayer();
        // تهيئة وقت بداية الخطوة للاعب التالي
        _initializeNextPlayerStepTime();
        emit(currentState.copyWith(
          currentStep: currentStep + 1,
          chosenNodes: newChosenNodes,
          score: newScore,
        ));
      }
    } else {
      const penalty = GameConstants.basePointsPerStep ~/ 2;
      final newScore =
          (currentState.score - penalty).clamp(0, double.infinity).toInt();

      // تحديث إحصائيات اللاعب للإجابة الخاطئة
      if (groupState != null && stepAnswerTime != null) {
        final currentPlayer = groupState!.currentPlayer;
        final updatedPlayers = groupState!.players.map((player) {
          if (player.id == currentPlayer.id) {
            return player.copyWith(
              wrongAnswers: player.wrongAnswers + 1,
              totalTimeSpent: player.totalTimeSpent + stepAnswerTime!,
              currentStepStartTime: null, // إعادة تعيين للخطوة التالية
            );
          }
          return player;
        }).toList();
        groupState = groupState!.copyWith(players: updatedPlayers);
      }

      emit(currentState.copyWith(score: newScore));
      _advancePlayer();
      // تهيئة وقت بداية الخطوة للاعب التالي
      _initializeNextPlayerStepTime();
    }
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

  void _onGameTimeOut(
    GameTimeOut event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameInProgress) return;

    _timer?.cancel();
    final currentState = state as GameInProgress;
    final completionTime = DateTime.now();
    final result = GameResult(
      puzzle: currentState.puzzle,
      score: currentState.score,
      timeSpent: currentState.startTime != null
          ? completionTime.difference(currentState.startTime!)
          : const Duration(seconds: 0),
      isPerfect: false,
      isDaily: false,
      isWin: false,
      completedAt: completionTime,
    );
    final progression = await progressionService.recordGameResult(result);
    await _adaptiveLearningRepository.recordResult(result);
    await _completeFamilySession(isWin: false);
    _advancePlayer();
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
  }

  Future<void> _handleGenericMoveGroup(
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
        isDaily: false,
        isWin: result.isCorrect,
        completedAt: completionTime,
      );
      final progression =
          await progressionService.recordGameResult(resultEntity);
      await _adaptiveLearningRepository.recordResult(resultEntity);
      await _completeFamilySession(isWin: result.isCorrect);
      _advancePlayer();

      emit(GameCompleted(
        puzzle: puzzle,
        chosenNodes: currentState.chosenNodes,
        score: newScore,
        timeSpent: timeSpent,
        isPerfect: result.isCorrect,
        progression: progression,
      ));
    } else {
      _advancePlayer();
      _initializeNextPlayerStepTime();
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
    await _handleGenericMoveGroup(currentState, result, emit);
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
    await _handleGenericMoveGroup(currentState, result, emit);
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
    await _handleGenericMoveGroup(currentState, result, emit);
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
    await _handleGenericMoveGroup(currentState, result, emit);
  }

  void _onGameReset(
    GameReset event,
    Emitter<GameState> emit,
  ) {
    _currentGameState = null;
    groupState = GroupGameState(
      players: List.generate(
        playersCount,
        (index) => Player(
          id: index,
          name: 'Player ${index + 1}',
          score: 0,
          correctAnswers: 0,
          wrongAnswers: 0,
          totalTimeSpent: const Duration(seconds: 0),
          answerTimes: [],
        ),
      ),
    );
    _timer?.cancel();
    _familySessionTracker.reset();
    emit(const GameInitial());
  }

  void nextPlayer() {
    _advancePlayer();
  }

  void _advancePlayer() {
    if (groupState != null) {
      final nextIndex =
          (groupState!.currentPlayerIndex + 1) % groupState!.players.length;
      groupState = groupState!.copyWith(currentPlayerIndex: nextIndex);
      _familySessionTracker.recordTurn();
    }
  }

  // تهيئة وقت بداية الخطوة للاعب الحالي
  void _initializeNextPlayerStepTime() {
    if (groupState != null) {
      final currentPlayer = groupState!.currentPlayer;
      final updatedPlayers = groupState!.players.map((player) {
        if (player.id == currentPlayer.id) {
          return player.copyWith(
            currentStepStartTime: DateTime.now(),
          );
        }
        return player;
      }).toList();
      groupState = groupState!.copyWith(players: updatedPlayers);
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _multiplayerSubscription?.cancel();
    _multiplayerService?.dispose();
    return super.close();
  }

  FamilySessionStats get sessionStats => _familySessionTracker.currentStats;

  Future<void> _completeFamilySession({required bool isWin}) async {
    final updated = _familySessionTracker.completeSession(isWin: isWin);
    if (updated != null) {
      await _familySessionStorage.saveStats(_currentGroupProfile, updated);
    }
  }

  Puzzle _createPuzzleFromCustom(Map<String, dynamic> customPuzzleData) {
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
    final typeStr = type.toString().replaceAll('RepresentationType.', '');
    return RepresentationType.values.firstWhere(
      (e) => e.toString().contains(typeStr) || e.name == typeStr.toLowerCase(),
      orElse: () => RepresentationType.text,
    );
  }
}
