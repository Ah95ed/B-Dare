import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mystery_link/core/constants/progression_constants.dart';
import 'package:mystery_link/core/utils/extensions.dart';
import 'package:mystery_link/features/progression/domain/entities/progression_summary.dart';
import 'package:mystery_link/features/progression/domain/entities/daily_challenge.dart';
import '../../../game/domain/entities/link_node.dart';
import '../../../game/domain/entities/puzzle.dart';
import '../../../game/presentation/bloc/base_game_bloc.dart';
import '../../../game/presentation/bloc/game_state.dart';
import '../../../game/data/services/score_service.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/colors.dart';
import '../../../adaptive_learning/data/services/brain_gym_service.dart';
import '../../../../l10n/app_localizations.dart';

class ResultScreen extends StatelessWidget {
  final String puzzleId;
  final List<LinkNode> chosenNodes;
  final int score;
  final Duration timeSpent;
  final bool isCompleted;
  final ProgressionSummary? progression;
  final bool isDaily;
  final bool isBrainGym;
  final int? brainGymTotalRounds;
  final int? brainGymCurrentRound;
  final int? brainGymAccumulatedScore;
  final int? brainGymLinks;
  final Puzzle? puzzle;

  const ResultScreen({
    super.key,
    required this.puzzleId,
    required this.chosenNodes,
    required this.score,
    required this.timeSpent,
    required this.isCompleted,
    this.progression,
    this.isDaily = false,
    this.isBrainGym = false,
    this.brainGymTotalRounds,
    this.brainGymCurrentRound,
    this.brainGymAccumulatedScore,
    this.brainGymLinks,
    this.puzzle,
  });

  Puzzle? _getPuzzleFromState(BuildContext context) {
    final state = context.read<BaseGameBloc>().state;
    if (state is GameCompleted) {
      return state.puzzle;
    } else if (state is GameTimeOutState) {
      return state.puzzle;
    } else if (state is GameInProgress) {
      return state.puzzle;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final puzzle = this.puzzle ?? _getPuzzleFromState(context);

    // Save score
    if (puzzle != null) {
      _saveScore(puzzle);
    }

    // Check if perfect win (all answers correct)
    final isPerfectWin = isCompleted &&
        chosenNodes.length == puzzle?.linksCount &&
        chosenNodes.asMap().entries.every((entry) {
          final stepIndex = entry.key;
          final chosenNode = entry.value;
          final correctNode = puzzle?.steps[stepIndex].correctOption?.node;
          return chosenNode.id == correctNode?.id;
        });

    final isBrainGymSession =
        isBrainGym && brainGymTotalRounds != null && brainGymCurrentRound != null;
    final isBrainGymFinalRound = isBrainGymSession &&
        brainGymCurrentRound! >= brainGymTotalRounds!;
    final sessionScore = brainGymAccumulatedScore ?? score;
    final brainGymFuture = isBrainGym
        ? context.read<BrainGymService>().getStatus()
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isCompleted
              ? (isPerfectWin ? l10n.perfectWin : l10n.gameOver)
              : l10n.timeUpMessage,
        ),
      ),
      body: puzzle == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Result Icon
                  Icon(
                    isPerfectWin
                        ? Icons.emoji_events
                        : isCompleted
                            ? Icons.check_circle
                            : Icons.timer_off,
                    size: 80,
                    color: isPerfectWin
                        ? AppColors.accent
                        : isCompleted
                            ? AppColors.success
                            : AppColors.error,
                  ),
                  const SizedBox(height: 16),

                  // Result Message
                  if (isPerfectWin)
                    Card(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.accent),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.perfectWin,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.accent,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (!isCompleted)
                    Card(
                      color: AppColors.error.withValues(alpha: 0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.timer_off, color: AppColors.error),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.timeUpMessage,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Score
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            'Your Score',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$score',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (brainGymFuture != null)
                    FutureBuilder<BrainGymStatus>(
                      future: brainGymFuture,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildBrainGymStatus(
                            context: context,
                            status: snapshot.data!,
                            isPerfect: isPerfectWin,
                            isFinalRound: isBrainGymFinalRound,
                            totalRounds: brainGymTotalRounds,
                            currentRound: brainGymCurrentRound,
                            sessionScore: sessionScore,
                          ),
                        );
                      },
                    ),

                  // Time Spent
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Time Spent',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            timeSpent.formatted,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (progression != null) ...[
                    _buildProgressSection(context, progression!),
                    const SizedBox(height: 24),
                  ],

                  // Correct Chain
                  Text(
                    'Correct Chain',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _buildChain(
                    context,
                    [
                      puzzle.start,
                      ...puzzle.steps.map((s) => s.correctOption!.node),
                      puzzle.end,
                    ],
                    Localizations.localeOf(context).languageCode,
                    isCorrect: true,
                  ),
                  const SizedBox(height: 24),

                  // Your Choices
                  Text(
                    'Your Choices',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _buildChain(
                    context,
                    [
                      puzzle.start,
                      ...chosenNodes,
                      puzzle.end,
                    ],
                    Localizations.localeOf(context).languageCode,
                    isCorrect: false,
                  ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  if (isBrainGymSession && !isBrainGymFinalRound)
                    ElevatedButton.icon(
                      onPressed: () => _startNextBrainGymRound(
                        context,
                        puzzle,
                      ),
                      icon: const Icon(Icons.flash_on),
                      label: Text(
                        'Next Brain Gym (${(brainGymCurrentRound ?? 1) + 1}/${brainGymTotalRounds ?? 3})',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.accent,
                      ),
                    ),
                  if (isBrainGymSession && !isBrainGymFinalRound)
                    const SizedBox(height: 12),

                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRouter.home,
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Back to Home'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // This would restart the game with same settings
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Play Again'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProgressSection(
    BuildContext context,
    ProgressionSummary summary,
  ) {
    final progress = summary.progress;
    final xpNeeded = ProgressionConstants.xpNeededForNextLevel(progress.level);
    final progressValue =
        xpNeeded == 0 ? 0.0 : (progress.xpInLevel / xpNeeded).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Level Progress',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Level ${progress.level}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '+${summary.xpEarned} XP',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 10,
                  backgroundColor: AppColors.textSecondary.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${progress.xpInLevel} / $xpNeeded XP to next level',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (summary.leveledUp) ...[
                  const SizedBox(height: 12),
                  const Chip(
                    avatar: Icon(Icons.flash_on, color: Colors.white),
                    label: Text(
                      'Level Up!',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: AppColors.secondary,
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildAchievementSection(context, summary),
        if (summary.newPhaseUnlocked && summary.unlockedPhase != null) ...[
          const SizedBox(height: 12),
          _buildPhaseUnlockBanner(context, summary.unlockedPhase!),
        ],
        const SizedBox(height: 12),
        _buildNextPhaseHint(context, summary),
        if (summary.dailyStatus.completedToday || isDaily)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: _buildDailyStatusCard(context, summary.dailyStatus),
          ),
      ],
    );
  }

  Widget _buildPhaseUnlockBanner(
    BuildContext context,
    PhaseDefinition phase,
  ) {
    return Card(
      color: AppColors.secondary.withValues(alpha: 0.15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.lock_open, color: AppColors.secondary, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Phase Unlocked!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${phase.title} is now available (up to ${phase.maxLinks} links).',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextPhaseHint(
    BuildContext context,
    ProgressionSummary summary,
  ) {
    final currentPhase =
        ProgressionConstants.phaseByIndex(summary.progress.unlockedPhaseIndex);
    final wins = summary.progress.phaseWins[currentPhase.id] ?? 0;
    final perfects = summary.progress.phasePerfectWins[currentPhase.id] ?? 0;
    final streak = summary.progress.phaseStreaks[currentPhase.id] ?? 0;

    int remaining(int required, int value) =>
        required <= 0 ? 0 : (required - value).clamp(0, required);

    final remainingWins = remaining(currentPhase.requiredWins, wins);
    final remainingPerfects =
        remaining(currentPhase.requiredPerfectWins, perfects);
    final remainingStreak = remaining(currentPhase.requiredStreak, streak);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Next Milestones',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (remainingWins > 0) Text('• $remainingWins more win(s) to advance.'),
        if (remainingPerfects > 0)
          Text('• $remainingPerfects more perfect chain(s).'),
        if (remainingStreak > 0)
          Text('• Maintain a streak of $remainingStreak.'),
        if (remainingWins == 0 &&
            remainingPerfects == 0 &&
            remainingStreak == 0)
          const Text('• Keep playing to reinforce mastery!'),
      ],
    );
  }

  Widget _buildAchievementSection(
    BuildContext context,
    ProgressionSummary summary,
  ) {
    if (summary.newlyUnlocked.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Achievements',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Keep going to unlock new achievements!',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'New Achievements',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: summary.newlyUnlocked
              .map(
                (achievement) => Chip(
                  avatar: const Icon(Icons.star, color: Colors.white, size: 18),
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        achievement.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        achievement.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.accent,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildDailyStatusCard(
    BuildContext context,
    DailyChallengeStatus status,
  ) {
    return Card(
      color: AppColors.info.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily Challenge',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Icon(
                  status.completedToday ? Icons.verified : Icons.event,
                  color: AppColors.info,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              status.completedToday
                  ? 'Great! You completed today\'s puzzle.'
                  : 'Come back tomorrow for a new challenge.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Streak: ${status.streakCount} day(s)',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Best daily score: ${status.bestScore}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChain(
    BuildContext context,
    List<LinkNode> nodes,
    String locale, {
    required bool isCorrect,
  }) {
    return Card(
      color: isCorrect
          ? AppColors.success.withValues(alpha: 0.1)
          : AppColors.error.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            for (int i = 0; i < nodes.length; i++) ...[
              Chip(
                label: Text(
                  nodes[i].getLocalizedLabel(locale),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                backgroundColor: isCorrect
                    ? AppColors.success.withValues(alpha: 0.2)
                    : AppColors.error.withValues(alpha: 0.2),
              ),
              if (i < nodes.length - 1)
                Icon(
                  Icons.arrow_forward,
                  color: isCorrect ? AppColors.success : AppColors.error,
                  size: 20,
                ),
            ],
          ],
        ),
      ),
    );
  }

  void _saveScore(Puzzle puzzle) {
    final scoreService = ScoreService();
    scoreService.saveScore(
      GameScore(
        score: score,
        linksCount: puzzle.linksCount,
        difficulty: puzzle.difficulty ?? 'medium',
        date: DateTime.now(),
        timeSpent: timeSpent,
        isCompleted: isCompleted,
      ),
    );
  }

  Widget _buildBrainGymStatus({
    required BuildContext context,
    required BrainGymStatus status,
    required bool isPerfect,
    required bool isFinalRound,
    required int? totalRounds,
    required int? currentRound,
    required int sessionScore,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final headline = isFinalRound
        ? l10n.brainGymSessionCompletedFinal
        : (isPerfect
            ? l10n.brainGymPerfectRoundHeadline
            : l10n.brainGymNewRoundHeadline);
    final streakText = status.completedToday
        ? l10n.brainGymCurrentStreak(status.streak)
        : l10n.brainGymStartNewStreak;
    return Card(
      color: AppColors.primary.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headline,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (totalRounds != null && currentRound != null) ...[
              const SizedBox(height: 6),
              Text(
                l10n.brainGymRoundProgress(
                  currentRound,
                  totalRounds,
                  sessionScore,
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 6),
            Text(
              streakText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.brainGymTotalSessions(status.totalSessions),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  void _startNextBrainGymRound(BuildContext context, Puzzle puzzle) {
    final nextRound = (brainGymCurrentRound ?? 1) + 1;
    final totalRounds = brainGymTotalRounds ?? 3;
    Navigator.pushReplacementNamed(
      context,
      AppRouter.game,
      arguments: {
        'representationType': puzzle.type,
        'linksCount': brainGymLinks ?? puzzle.linksCount,
        'gameMode': 'brainGym',
        'category': puzzle.category,
        'brainGymTotalRounds': totalRounds,
        'brainGymCurrentRound': nextRound,
        'brainGymAccumulatedScore': brainGymAccumulatedScore ?? score,
      },
    );
  }
}
