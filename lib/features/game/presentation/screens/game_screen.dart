import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/link_node.dart';
import '../../domain/entities/game_type.dart';
import '../bloc/base_game_bloc.dart';
import '../bloc/game_event.dart';
import '../bloc/game_state.dart';
import '../bloc/group_game_bloc.dart';
import '../widgets/puzzle_header.dart';
import '../widgets/step_indicator.dart';
import '../widgets/timer_widget.dart';
import '../widgets/options_grid.dart';
import '../widgets/feedback_overlay.dart';
import '../widgets/puzzle_context_banner.dart';
import '../widgets/group_player_roster.dart';
import '../widgets/guided_mode_hint_card.dart';
import '../widgets/memory_flip_board.dart';
import '../widgets/spot_the_odd_grid.dart';
import '../widgets/sort_solve_area.dart';
import '../widgets/story_tiles_board.dart';
import '../widgets/shadow_match_grid.dart';
import '../widgets/emoji_circuit_board.dart';
import '../widgets/cipher_tiles_board.dart';
import '../widgets/spot_the_change_viewer.dart';
import '../widgets/color_harmony_palette.dart';
import '../widgets/puzzle_sentence_builder.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../thinking_assistant/presentation/bloc/thinking_assistant_bloc.dart';
import '../../../thinking_assistant/presentation/widgets/hint_button.dart';
import '../../../thinking_assistant/presentation/widgets/thinking_analysis_widget.dart';
import '../../../adaptive_learning/data/services/brain_gym_service.dart';
import '../../../group/domain/entities/family_session_stats.dart';
import '../../../adaptive_learning/presentation/bloc/adaptive_learning_bloc.dart';
import '../../../../l10n/app_localizations.dart';

class GameScreen extends StatefulWidget {
  final GameType? gameType;
  final RepresentationType representationType;
  final int linksCount;
  final String gameMode;
  final int? playersCount;
  final String? category;
  final String? groupProfile;
  final List<Map<String, dynamic>>? customPlayers;
  final Map<String, dynamic>? customPuzzle;
  final int? brainGymTotalRounds;
  final int? brainGymCurrentRound;
  final int brainGymAccumulatedScore;

  const GameScreen({
    super.key,
    this.gameType,
    required this.representationType,
    required this.linksCount,
    required this.gameMode,
    this.playersCount,
    this.category,
    this.groupProfile,
    this.customPlayers,
    this.customPuzzle,
    this.brainGymTotalRounds,
    this.brainGymCurrentRound,
    this.brainGymAccumulatedScore = 0,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _showFeedback = false;
  bool? _lastAnswerCorrect;
  bool get _isGuided => widget.gameMode == 'guided';
  bool get _isFinalBrainGymRound {
    if (widget.gameMode != 'brainGym') return false;
    final total = widget.brainGymTotalRounds;
    final current = widget.brainGymCurrentRound;
    if (total == null || current == null) return false;
    return current >= total;
  }

  Widget _buildGameContent(BuildContext context, GameInProgress state) {
    final gameType = state.gameType;

    switch (gameType) {
      case GameType.memoryFlip:
        return MemoryFlipBoard(state: state);
      case GameType.spotTheOdd:
        return SpotTheOddGrid(state: state);
      case GameType.sortSolve:
        return SortSolveArea(state: state);
      case GameType.storyTiles:
        return StoryTilesBoard(state: state);
      case GameType.shadowMatch:
        return ShadowMatchGrid(state: state);
      case GameType.emojiCircuit:
        return EmojiCircuitBoard(state: state);
      case GameType.cipherTiles:
        return CipherTilesBoard(state: state);
      case GameType.spotTheChange:
        return SpotTheChangeViewer(state: state);
      case GameType.colorHarmony:
        return ColorHarmonyPalette(state: state);
      case GameType.puzzleSentence:
        return PuzzleSentenceBuilder(state: state);
      case GameType.mysteryLink:
        // النمط الأصلي - Options Grid
        if (state.puzzle.steps.isEmpty || 
            state.currentStep < 1 || 
            state.currentStep > state.puzzle.steps.length) {
          return const Center(
            child: Text('Invalid puzzle state'),
          );
        }
        final currentStep = state.puzzle.steps[state.currentStep - 1];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: OptionsGrid(
            step: currentStep,
            selectedNode: null,
            showResult: false,
            onOptionSelected: (node) {
              final correctNode = currentStep.correctOption?.node;
              final isCorrect = correctNode?.id == node.id;

              setState(() {
                _showFeedback = true;
                _lastAnswerCorrect = isCorrect;
              });

              context.read<BaseGameBloc>().add(
                    StepOptionSelected(
                      stepOrder: state.currentStep,
                      selectedNode: node,
                    ),
                  );
            },
          ),
        );
    }
  }

  bool _gameStarted = false;

  @override
  void initState() {
    super.initState();
    // تأجيل بدء اللعبة حتى يكون context جاهزاً
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_gameStarted) {
        _gameStarted = true;
        context.read<ThinkingAssistantBloc>().add(const ThinkingAssistantReset());
        context.read<BaseGameBloc>().add(
              GameStarted(
                gameType: widget.gameType ?? GameType.mysteryLink,
                representationType: widget.representationType,
                linksCount: widget.linksCount,
                gameMode: widget.gameMode,
                playersCount: widget.playersCount,
                category: widget.category,
                groupProfile: widget.groupProfile,
                customPlayers: widget.customPlayers,
                customPuzzle: widget.customPuzzle,
              ),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.gameMode == 'group' && widget.groupProfile != null
              ? 'Group: ${widget.groupProfile}'
              : 'Mystery Link',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context
                  .read<ThinkingAssistantBloc>()
                  .add(const ThinkingAssistantReset());
              context.read<BaseGameBloc>().add(const GameReset());
              context.read<BaseGameBloc>().add(
                    GameStarted(
                      gameType: widget.gameType ?? GameType.mysteryLink,
                      representationType: widget.representationType,
                      linksCount: widget.linksCount,
                      gameMode: widget.gameMode,
                      playersCount: widget.playersCount,
                      category: widget.category,
                      groupProfile: widget.groupProfile,
                      customPlayers: widget.customPlayers,
                      customPuzzle: widget.customPuzzle,
                    ),
                  );
            },
          ),
        ],
      ),
      body: BlocConsumer<BaseGameBloc, GameState>(
        listener: (context, state) {
          if (state is GameCompleted) {
            _navigateToResult(state);
          } else if (state is GameTimeOutState) {
            _navigateToResult(state);
          } else if (state is GameErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GameLoading) {
            return const LoadingWidget(message: 'Loading puzzle...');
          }

          if (state is GameErrorState) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: () {
                context.read<BaseGameBloc>().add(
                      GameStarted(
                        gameType: widget.gameType ?? GameType.mysteryLink,
                        representationType: widget.representationType,
                        linksCount: widget.linksCount,
                        gameMode: widget.gameMode,
                        playersCount: widget.playersCount,
                        category: widget.category,
                        groupProfile: widget.groupProfile,
                        customPlayers: widget.customPlayers,
                        customPuzzle: widget.customPuzzle,
                      ),
                    );
              },
            );
          }

          if (state is GameInProgress) {
            return _buildGameView(context, state);
          }

          return const LoadingWidget();
        },
      ),
    );
  }

  Widget _buildGameView(BuildContext context, GameInProgress state) {
    final currentStepIndex = state.currentStep - 1;
    final currentStep = state.puzzle.steps[currentStepIndex];
    final totalTime = state.puzzle.timeLimit;
    GroupGameState? runtimeGroupState;
    FamilySessionStats? sessionStats;
    if (widget.gameMode == 'group') {
      final bloc = context.read<BaseGameBloc>();
      if (bloc is GroupGameBloc) {
        runtimeGroupState = bloc.groupState;
        sessionStats = bloc.sessionStats;
      }
    }

    return Column(
      children: [
        // Scrollable header section
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header with Start/End cards
                PuzzleHeader(
                  startNode: state.puzzle.start,
                  endNode: state.puzzle.end,
                  chosenNodes: state.chosenNodes,
                ),
                if (_isGuided) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      color: Colors.lightBlue.withValues(alpha: 0.15),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(Icons.lightbulb, color: Colors.lightBlue),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                Localizations.localeOf(context).languageCode == 'ar'
                                    ? AppLocalizations.of(context)!
                                        .guidedModeHint
                                    : 'Read the hint before choosing: Look for the link that connects the current card to the target.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (widget.category != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        label: Text('Theme: ${widget.category}'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                if (widget.gameMode == 'group') ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GroupPlayerRoster(
                      players: _buildGroupPlayers(runtimeGroupState),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (sessionStats != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _FamilyBondingCard(stats: sessionStats),
                    ),
                  if (sessionStats != null) const SizedBox(height: 12),
                ],

                // Step Indicator
                StepIndicator(
                  currentStep: state.currentStep,
                  totalSteps: state.puzzle.linksCount,
                ),

                const SizedBox(height: 12),

                // Puzzle Context Banner (فقط للـ Mystery Link)
                if (state.gameType == GameType.mysteryLink)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: PuzzleContextBanner(
                      puzzle: state.puzzle,
                      requestedCategory: widget.category,
                      notice: state.notice,
                    ),
                  ),

                if (_isGuided) ...[
                  const SizedBox(height: 12),
                  GuidedModeHintCard(
                    puzzle: state.puzzle,
                    currentStep: state.currentStep,
                    locale: Localizations.localeOf(context),
                    onHintRequested: (step) {
                      context.read<BaseGameBloc>().add(HintUsed(stepOrder: step));
                    },
                    onPracticeRequested: (customPuzzle) {
                      context.read<BaseGameBloc>().add(const GameReset());
                      context.read<BaseGameBloc>().add(
                            GameStarted(
                              gameType: widget.gameType ?? GameType.mysteryLink,
                              representationType:
                                  _representationFromCustom(customPuzzle),
                              linksCount:
                                  (customPuzzle['steps'] as List<dynamic>).length,
                              gameMode: widget.gameMode,
                              playersCount: widget.playersCount,
                              category: widget.category,
                              groupProfile: widget.groupProfile,
                              customPlayers: widget.customPlayers,
                              customPuzzle: customPuzzle,
                            ),
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            Localizations.localeOf(context).languageCode == 'ar'
                                ? AppLocalizations.of(context)!
                                    .samplePuzzleLoaded
                                : 'Sample practice puzzle loaded',
                          ),
                        ),
                      );
                    },
                  ),
                ],

                // Timer
                TimerWidget(
                  remainingSeconds: state.remainingSeconds,
                  totalSeconds: totalTime,
                  isWarning: state.remainingSeconds <= 10,
                ),

                // Score
                Text(
                  widget.gameMode == 'group'
                      ? _groupScoreLabel(runtimeGroupState, state.score)
                      : 'Score: ${state.score}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // Game Content - حسب نوع اللعبة (fixed height)
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Stack(
            children: [
              _buildGameContent(context, state),
              // Feedback Overlay
              if (_showFeedback && _lastAnswerCorrect != null)
                FeedbackOverlay(
                  isCorrect: _lastAnswerCorrect!,
                  onComplete: () {
                    setState(() {
                      _showFeedback = false;
                      _lastAnswerCorrect = null;
                    });
                  },
                ),
            ],
          ),
        ),

        // Thinking Assistant section (scrollable)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BlocBuilder<ThinkingAssistantBloc, ThinkingAssistantState>(
              builder: (context, assistantState) {
                final assistantBloc = context.read<ThinkingAssistantBloc>();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thinking Assistant',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    HintButton(
                      level: assistantState.level,
                      isLoading:
                          assistantState.status ==
                              ThinkingAssistantStatus.loading,
                      onLevelChanged: (level) {
                        assistantBloc
                            .add(ThinkingAssistantLevelChanged(level));
                      },
                      onRequest: () {
                        assistantBloc.add(
                          ThinkingAssistantHintRequested(
                            puzzle: state.puzzle,
                            step: currentStep,
                            chosenNodes: state.chosenNodes,
                          ),
                        );
                        context.read<BaseGameBloc>().add(
                              HintUsed(stepOrder: state.currentStep),
                            );
                      },
                    ),
                    if (assistantState.status ==
                            ThinkingAssistantStatus.error &&
                        assistantState.error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        assistantState.error!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color:
                                  Theme.of(context).colorScheme.error,
                            ),
                      ),
                    ],
                    if (assistantState.insight != null)
                      ThinkingAnalysisWidget(
                        insight: assistantState.insight!,
                      ),
                    const SizedBox(height: 32),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToResult(GameState state) {
    if (mounted) {
      context
          .read<AdaptiveLearningBloc>()
          .add(const AdaptiveLearningRefreshRequested());
    }
    if (state is GameCompleted) {
      if (widget.gameMode == 'brainGym' && _isFinalBrainGymRound) {
        context.read<BrainGymService>().recordSessionCompletion();
      }
      final timeSpent = state.timeSpent;
      final accumulatedScore =
          widget.brainGymAccumulatedScore + state.score;
      Navigator.pushReplacementNamed(
        context,
        AppRouter.result,
        arguments: {
          'puzzleId': state.puzzle.id,
          'chosenNodes': state.chosenNodes,
          'score': state.score,
          'timeSpent': timeSpent,
          'isCompleted': true,
          'progression': state.progression,
          'isDaily': widget.gameMode == 'daily',
          'isBrainGym': widget.gameMode == 'brainGym',
          'brainGymTotalRounds': widget.brainGymTotalRounds,
          'brainGymCurrentRound': widget.brainGymCurrentRound,
          'brainGymAccumulatedScore': accumulatedScore,
          'brainGymLinks': widget.linksCount,
          'puzzle': state.puzzle,
        },
      );
    } else if (state is GameTimeOutState) {
      final accumulatedScore =
          widget.brainGymAccumulatedScore + state.score;
      Navigator.pushReplacementNamed(
        context,
        AppRouter.result,
        arguments: {
          'puzzleId': state.puzzle.id,
          'chosenNodes': state.chosenNodes,
          'score': state.score,
          'timeSpent': const Duration(seconds: 0),
          'isCompleted': false,
          'progression': state.progression,
          'isDaily': widget.gameMode == 'daily',
          'isBrainGym': widget.gameMode == 'brainGym',
          'brainGymTotalRounds': widget.brainGymTotalRounds,
          'brainGymCurrentRound': widget.brainGymCurrentRound,
          'brainGymAccumulatedScore': accumulatedScore,
          'brainGymLinks': widget.linksCount,
          'puzzle': state.puzzle,
        },
      );
    }
  }

  List<PlayerDisplayInfo> _buildGroupPlayers(GroupGameState? state) {
    if (state != null) {
      return state.players
          .map(
            (player) => PlayerDisplayInfo(
              name: player.name,
              isHost: player.id == 0,
              isCurrent: player.id == state.currentPlayer.id,
              score: player.score,
            ),
          )
          .toList();
    }

    final custom = widget.customPlayers;
    if (custom != null && custom.isNotEmpty) {
      return custom
          .asMap()
          .entries
          .map(
            (entry) => PlayerDisplayInfo(
              name: (entry.value['name'] as String?)?.trim().isEmpty ?? true
                  ? 'Player ${entry.key + 1}'
                  : entry.value['name'] as String,
              isHost: entry.value['isHost'] == true,
              isCurrent: entry.key == 0,
              score: 0,
            ),
          )
          .toList();
    }

    final count = widget.playersCount ?? 0;
    if (count == 0) {
      return const [];
    }
    return List.generate(
      count,
      (index) => PlayerDisplayInfo(
        name: 'Player ${index + 1}',
        isHost: index == 0,
        isCurrent: index == 0,
        score: 0,
      ),
    );
  }

  String _groupScoreLabel(GroupGameState? state, int teamScore) {
    if (state == null) {
      return 'Group Score: $teamScore';
    }
    final current = state.currentPlayer;
    return '${current.name}\'s turn • ${current.score} pts | Team $teamScore';
  }

  RepresentationType _representationFromCustom(Map<String, dynamic> puzzle) {
    final typeValue = puzzle['type']?.toString().toLowerCase() ?? 'text';
    switch (typeValue) {
      case 'icon':
        return RepresentationType.icon;
      case 'image':
        return RepresentationType.image;
      case 'event':
        return RepresentationType.event;
      case 'text':
      default:
        return RepresentationType.text;
    }
  }
}

class _FamilyBondingCard extends StatelessWidget {
  final FamilySessionStats stats;

  const _FamilyBondingCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stats.groupProfile != null
                  ? l10n.familySessionTitleWithProfileInGame(
                      stats.groupProfile ?? '',
                    )
                  : l10n.familySessionTitleInGame,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                _StatBlock(
                  label: l10n.sessionsShortLabel,
                  value: '${stats.sessionsPlayed}',
                ),
                _StatBlock(
                  label: l10n.winsShortLabel,
                  value: '${stats.wins}',
                ),
                _StatBlock(
                  label: l10n.lossesShortLabel,
                  value: '${stats.losses}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${l10n.lastSessionShort}: ${stats.lastSessionAt != null ? _formatRelative(context, stats.lastSessionAt!) : '—'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  String _formatRelative(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) {
      return l10n.relativeMinutes(diff.inMinutes);
    } else if (diff.inHours < 24) {
      return l10n.relativeHours(diff.inHours);
    }
    return l10n.relativeDays(diff.inDays);
  }
}

class _StatBlock extends StatelessWidget {
  final String label;
  final String value;

  const _StatBlock({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
