import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/progression_constants.dart';
import '../../../../core/localization/supported_languages.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/settings/app_settings_cubit.dart';
import '../../../../core/theme/colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../progression/data/services/progression_service.dart';
import '../../../progression/domain/entities/daily_challenge.dart';
import '../../../progression/domain/entities/player_progress.dart';
import '../../../leaderboard/data/services/leaderboard_service.dart';
import '../../../leaderboard/domain/entities/leaderboard_entry.dart';
import '../../../adaptive_learning/presentation/bloc/adaptive_learning_bloc.dart';
import '../../../adaptive_learning/presentation/widgets/difficulty_indicator.dart';
import '../../../adaptive_learning/data/services/brain_gym_service.dart';
import '../../../adaptive_learning/domain/entities/difficulty_prediction.dart';
import '../../../adaptive_learning/domain/entities/player_cognitive_profile.dart';
import '../../../group/data/services/family_session_storage.dart';
import '../../../group/domain/entities/family_session_stats.dart';
import '../../../game/domain/entities/game_type.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ProgressionService _progressionService;
  late BrainGymService _brainGymService;
  late FamilySessionStorage _familySessionStorage;
  Future<_DashboardData>? _dashboardFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _progressionService = context.read<ProgressionService>();
    _brainGymService = context.read<BrainGymService>();
    _familySessionStorage = context.read<FamilySessionStorage>();
    _dashboardFuture ??= _loadDashboard();
  }

  Widget _buildFuturePlaybookCard(
    BuildContext context,
    List<FuturePlaySuggestion> suggestions,
    bool enableMotion,
  ) {
    if (suggestions.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;
    final duration =
        enableMotion ? const Duration(milliseconds: 300) : Duration.zero;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_graph,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.futurePlaybook,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        l10n.futurePlaybookSubtitle,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: const Text('Beta'),
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.1),
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...suggestions.map(
              (suggestion) => AnimatedOpacity(
                key: ValueKey(suggestion.title),
                duration: duration,
                opacity: 1,
                child: _FutureSuggestionTile(
                  suggestion: suggestion,
                  enableMotion: enableMotion,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrainGymCard(
    BuildContext context,
    DifficultyPrediction prediction,
    PlayerCognitiveProfile profile,
    BrainGymStatus status,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final themeSuggestion = prediction.recommendedThemes.isNotEmpty
        ? prediction.recommendedThemes.first
        : null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Brain Gym',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '3 روابط ذكية بسرعة ${prediction.suggestedTimePerStep.inSeconds}s/خطوة'
              '${themeSuggestion != null ? ' · موضوع: $themeSuggestion' : ''}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  status.completedToday ? Icons.check_circle : Icons.timelapse,
                  color: status.completedToday
                      ? Colors.green
                      : Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
            Text(
              status.completedToday
                  ? l10n.dailySessionStatusCompleted(status.streak)
                  : l10n.dailySessionStatusNotStarted(status.streak),
            ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.dailySessionTotalSessions(status.totalSessions),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => _startBrainGymSession(prediction, profile),
                icon: const Icon(Icons.flash_on),
                label: Text(l10n.brainGymStartNow),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyBondingCard(
    BuildContext context,
    FamilySessionStats stats,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.family_restroom, color: AppColors.secondary),
                const SizedBox(width: 8),
                Text(
                  stats.groupProfile != null
                      ? l10n.familySessionsTitleWithProfile(
                          stats.groupProfile!,
                        )
                      : l10n.familySessionsTitleDefault,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                 _buildMiniStat(
                   context,
                   label: l10n.sessionsLabel,
                   value: '${stats.sessionsPlayed}',
                 ),
                 _buildMiniStat(
                   context,
                   label: l10n.winsLabel,
                   value: '${stats.wins}',
                 ),
                 _buildMiniStat(
                   context,
                   label: l10n.lastSessionLabel,
                   value: stats.lastSessionAt != null
                       ? _relativeDate(stats.lastSessionAt!)
                       : '—',
                 ),
              ],
            ),
            const SizedBox(height: 12),
             ElevatedButton.icon(
               onPressed: () {
                 Navigator.pushNamed(
                   context,
                   AppConstants.routeCreateGroup,
                   arguments: {
                     'maxLinksAllowed': stats.totalTurns > 0
                         ? stats.totalTurns
                         : ProgressionConstants.phases.first.maxLinks,
                   },
                 );
               },
               icon: const Icon(Icons.group),
               label: Text(l10n.familyStartNewSession),
             ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyHubSection(
    BuildContext context,
    FamilySessionStats stats,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final bonding = stats.sessionsPlayed == 0
        ? 0.0
        : (stats.wins / stats.sessionsPlayed).clamp(0.0, 1.0);
    final challengeText =
        l10n.familyWeeklyGoal(stats.wins % 3);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonding Meter',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: bonding,
                  minHeight: 10,
                  backgroundColor:
                      AppColors.textSecondary.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.familyWinsSessionsSummary(
                    stats.wins,
                    stats.sessionsPlayed,
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                 Text(
                   stats.lastSessionAt != null
                       ? '${l10n.lastSessionLabel}: ${_relativeDate(stats.lastSessionAt!)}'
                       : l10n.familyNoSessionYet,
                   style: Theme.of(context).textTheme.bodySmall,
                 ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: AppColors.primary.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Challenge of the Week',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  challengeText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                 ElevatedButton.icon(
                   onPressed: () => Navigator.pushNamed(
                     context,
                     AppConstants.routeCreateGroup,
                     arguments: {
                       'maxLinksAllowed': stats.totalTurns > 0
                           ? stats.totalTurns
                           : ProgressionConstants.phases.first.maxLinks,
                     },
                   ),
                   icon: const Icon(Icons.play_arrow),
                   label: Text(l10n.familyStartNewSession),
                 ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<_DashboardData> _loadDashboard() async {
    final progress = await _progressionService.getProgress();
    final dailyStatus = await _progressionService.getDailyStatus();
    final phase =
        ProgressionConstants.phaseByIndex(progress.unlockedPhaseIndex);
    final brainGymStatus = await _brainGymService.getStatus();
    final familyStats = await _familySessionStorage.loadMostRecent();
    final suggestions = _buildFutureSuggestions(
      progress: progress,
      dailyStatus: dailyStatus,
      brainGymStatus: brainGymStatus,
      familyStats: familyStats,
    );
    return _DashboardData(
      progress,
      dailyStatus,
      phase,
      brainGymStatus,
      familyStats,
      suggestions,
    );
  }

  List<FuturePlaySuggestion> _buildFutureSuggestions({
    required PlayerProgress progress,
    required DailyChallengeStatus dailyStatus,
    required BrainGymStatus brainGymStatus,
    required FamilySessionStats? familyStats,
  }) {
    final suggestions = <FuturePlaySuggestion>[];

    suggestions.add(
      FuturePlaySuggestion(
        icon: Icons.auto_awesome,
        title: 'AI Coach Preview',
        description:
            'Level ${progress.level + 1} will unlock predictive hints powered by your play history.',
        badge: 'AI',
        color: AppColors.primary,
      ),
    );

    if (familyStats?.sessionsPlayed != null &&
        familyStats!.sessionsPlayed > 0) {
      suggestions.add(
        FuturePlaySuggestion(
          icon: Icons.groups_2,
          title: 'Clubs & Creators',
          description:
              'Your ${familyStats.sessionsPlayed} family sessions qualify you for shared club challenges.',
          badge: 'Community',
          color: AppColors.secondary,
        ),
      );
    }

    suggestions.add(
      const FuturePlaySuggestion(
        icon: Icons.view_in_ar,
        title: 'AR Puzzle Hunt',
        description:
            'memoryFlip and spotTheOdd are being prepared for WebXR once devices support it.',
        badge: 'AR',
        color: AppColors.modeDaily,
      ),
    );

    if (dailyStatus.streakCount > 2 || brainGymStatus.streak > 2) {
      suggestions.add(
        FuturePlaySuggestion(
          icon: Icons.emoji_events_outlined,
          title: 'Seasonal World League',
          description:
              'Daily streak ${dailyStatus.streakCount} places you early on the seasonal leaderboard rollout.',
          badge: 'League',
          color: AppColors.accent,
        ),
      );
    }

    return suggestions;
  }

  void _refreshDashboard() {
    setState(() {
      _dashboardFuture = _loadDashboard();
    });
  }

  void _openSettingsSheet() {
    final currentSettings = context.read<AppSettingsCubit>().state;
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        double tempScale = currentSettings.textScale;
        Locale tempLocale = currentSettings.locale;
        ThemeMode tempThemeMode = currentSettings.themeMode;
        bool tempDynamicColors = currentSettings.enableDynamicColors;
        bool tempMotion = currentSettings.enableMotion;
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.accessibilityAndLanguage,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.language,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Wrap(
                      spacing: 8,
                      children: SupportedLanguages.all.map((language) {
                        final selected = tempLocale.languageCode ==
                            language.locale.languageCode;
                        return ChoiceChip(
                          label: Text(language.name),
                          selected: selected,
                          onSelected: (_) {
                            setState(() => tempLocale = language.locale);
                            context
                                .read<AppSettingsCubit>()
                                .setLocale(language.locale);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.textSize,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Slider(
                      value: tempScale,
                      min: 0.8,
                      max: 1.6,
                      divisions: 8,
                      label: tempScale.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() => tempScale = value);
                        context.read<AppSettingsCubit>().setTextScale(value);
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Current: ${(tempScale * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.themeMode,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _ThemeOptionChip(
                          label: l10n.systemTheme,
                          selected: tempThemeMode == ThemeMode.system,
                          onSelected: () {
                            setState(() => tempThemeMode = ThemeMode.system);
                            context
                                .read<AppSettingsCubit>()
                                .setThemeMode(ThemeMode.system);
                          },
                        ),
                        _ThemeOptionChip(
                          label: l10n.lightThemeOption,
                          selected: tempThemeMode == ThemeMode.light,
                          onSelected: () {
                            setState(() => tempThemeMode = ThemeMode.light);
                            context
                                .read<AppSettingsCubit>()
                                .setThemeMode(ThemeMode.light);
                          },
                        ),
                        _ThemeOptionChip(
                          label: l10n.darkThemeOption,
                          selected: tempThemeMode == ThemeMode.dark,
                          onSelected: () {
                            setState(() => tempThemeMode = ThemeMode.dark);
                            context
                                .read<AppSettingsCubit>()
                                .setThemeMode(ThemeMode.dark);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.dynamicColors),
                      subtitle: Text(l10n.dynamicColorsSubtitle),
                      value: tempDynamicColors,
                      onChanged: (value) {
                        setState(() => tempDynamicColors = value);
                        context
                            .read<AppSettingsCubit>()
                            .setDynamicColorsEnabled(value);
                      },
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.motionEffects),
                      subtitle: Text(l10n.motionEffectsSubtitle),
                      value: tempMotion,
                      onChanged: (value) {
                        setState(() => tempMotion = value);
                        context
                            .read<AppSettingsCubit>()
                            .setMotionEnabled(value);
                      },
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.close),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _startModeSelection(String gameMode, int maxLinksAllowed) async {
    await Navigator.pushNamed(
      context,
      AppRouter.modeSelection,
      arguments: {
        'gameMode': gameMode,
        'maxLinksAllowed': maxLinksAllowed,
      },
    );
    _refreshDashboard();
  }

  Future<void> _startDailyChallenge() async {
    final config = _progressionService.getTodayConfig();
    await Navigator.pushNamed(
      context,
      AppRouter.game,
      arguments: {
        'representationType': config.representationType,
        'linksCount': config.linksCount,
        'gameMode': 'daily',
      },
    );
    _refreshDashboard();
  }

  Future<void> _startBrainGymSession(
    DifficultyPrediction prediction,
    PlayerCognitiveProfile profile,
  ) async {
    final category = prediction.recommendedThemes.isNotEmpty
        ? prediction.recommendedThemes.first
        : null;
    await Navigator.pushNamed(
      context,
      AppRouter.game,
      arguments: {
        'representationType': profile.preferredRepresentation,
        'linksCount': prediction.recommendedLinks,
        'gameMode': 'brainGym',
        'category': category,
        'brainGymTotalRounds': 3,
        'brainGymCurrentRound': 1,
        'brainGymAccumulatedScore': 0,
      },
    );
    _refreshDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final future = _dashboardFuture ??= _loadDashboard();
    final appSettings = context.watch<AppSettingsCubit>().state;

    final size = MediaQuery.of(context).size;
    final isWide = size.width > 1024;
    const contentMaxWidth = 1200.0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.background,
              AppColors.background.withValues(alpha: 0.9),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 48 : 24,
              vertical: 24,
            ),
            child: FutureBuilder<_DashboardData>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final l10n = AppLocalizations.of(context)!;

                final data = snapshot.data;
                if (data == null) {
                  final l10n = AppLocalizations.of(context)!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.error),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _refreshDashboard,
                        child: Text(l10n.retry),
                      ),
                    ],
                  );
                }

                final modeBars = [
                  _ModeBarItem(
                    title: l10n.guidedModeTitle,
                    description: l10n.guidedModeDescription,
                    icon: Icons.psychology,
                    color: AppColors.modeGuided,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppConstants.routeGuided,
                    ),
                  ),
                  _ModeBarItem(
                    title: l10n.soloMode,
                    description: l10n.soloModeDescription,
                    icon: Icons.person,
                    color: AppColors.modeSolo,
                    onTap: () => _startModeSelection(
                      'solo',
                      data.phase.maxLinks,
                    ),
                  ),
                  _ModeBarItem(
                    title: l10n.createGroupTitle,
                    description: l10n.createGroupDescription,
                    icon: Icons.group_add,
                    color: AppColors.modeGroup,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppConstants.routeCreateGroup,
                      arguments: {
                        'maxLinksAllowed': data.phase.maxLinks,
                      },
                    ),
                  ),
                  _ModeBarItem(
                    title: 'Join Game',
                    description: 'Join a game using invite code',
                    icon: Icons.login,
                    color: AppColors.secondary,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppConstants.routeJoinGame,
                    ),
                  ),
                  _ModeBarItem(
                    title: 'Practice Mode',
                    description: 'Learn and practice with easy puzzles',
                    icon: Icons.school,
                    color: AppColors.modePractice,
                    onTap: () => _startModeSelection(
                      'practice',
                      data.phase.maxLinks,
                    ),
                  ),
                  _ModeBarItem(
                    title: 'Brain Mini-Games',
                    description: 'Quick games for memory, reflex, and focus',
                    icon: Icons.extension,
                    color: AppColors.modeGuided,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppConstants.routeMinigames,
                    ),
                  ),
                  _ModeBarItem(
                    title: 'Daily Challenge',
                    description: data.dailyStatus.completedToday
                        ? 'You conquered today\'s puzzle! Come back tomorrow.'
                        : 'One curated puzzle each day. Current streak: ${data.dailyStatus.streakCount}',
                    icon: Icons.calendar_today,
                    color: AppColors.modeDaily,
                    onTap: _startDailyChallenge,
                  ),
                  _ModeBarItem(
                    title: l10n.globalTournamentsTitle,
                    description: l10n.globalTournamentsDescription,
                    icon: Icons.emoji_events,
                    color: AppColors.accent,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppConstants.routeTournaments,
                    ),
                  ),
                  _ModeBarItem(
                    title: l10n.levelsChallenges,
                    description: l10n.levelsChallengesSubtitle,
                    icon: Icons.map,
                    color: AppColors.modeSolo,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppConstants.routeLevelSelection,
                      arguments: {
                        'gameType': GameType.mysteryLink,
                        'title': GameType.mysteryLink.nameEn,
                      },
                    ),
                  ),
                ];

                return Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: contentMaxWidth,
                      minWidth: isWide ? 900 : 0,
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isWide ? 48 : 20,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _HeaderRow(onSettingsPressed: _openSettingsSheet),
                            const SizedBox(height: 12),
                            _buildHeroSection(context, data),
                            const SizedBox(height: 12),
                            _buildFuturePlaybookCard(
                              context,
                              data.futureSuggestions,
                              appSettings.enableMotion,
                            ),
                            BlocBuilder<AdaptiveLearningBloc,
                                AdaptiveLearningState>(
                              builder: (context, adaptiveState) {
                                if (adaptiveState.status ==
                                    AdaptiveLearningStatus.loading) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: LinearProgressIndicator(),
                                  );
                                }
                                final profile = adaptiveState.profile;
                                final prediction = adaptiveState.prediction;
                                if (adaptiveState.status !=
                                        AdaptiveLearningStatus.ready ||
                                    profile == null ||
                                    prediction == null) {
                                  return const SizedBox.shrink();
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DifficultyIndicator(
                                      profile: profile,
                                      prediction: prediction,
                                      learningPath: adaptiveState.learningPath,
                                    ),
                                    const SizedBox(height: 12),
                                    _buildBrainGymCard(
                                      context,
                                      prediction,
                                      profile,
                                      data.brainGymStatus,
                                    ),
                                    if (data.familyStats != null) ...[
                                      const SizedBox(height: 12),
                                      _buildFamilyBondingCard(
                                        context,
                                        data.familyStats!,
                                      ),
                                    ],
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            _ModeBarRibbon(items: modeBars),
                            const SizedBox(height: 32),
                            const _SectionTitle(
                              title: 'Progress Highlights',
                              subtitle:
                                  'Track your XP, current phase, and streak at a glance.',
                            ),
                            const SizedBox(height: 12),
                            _buildInsightPanel(context, data, isWide),
                            const SizedBox(height: 32),
                            const _SectionTitle(
                              title: 'What\'s Next',
                              subtitle:
                                  'تابع التحديات اليومية والإنجازات الجديدة لتحافظ على حماسك.',
                            ),
                            const SizedBox(height: 12),
                            _buildNextMilestoneCard(
                              context,
                              progress: data.progress,
                            ),
                            if (data.familyStats != null) ...[
                              const SizedBox(height: 32),
                              const _SectionTitle(
                                title: 'Family Hub',
                                subtitle:
                                    'تابع جلسات العائلة والتحدي الأسبوعي القادم.',
                              ),
                              const SizedBox(height: 12),
                              _buildFamilyHubSection(
                                  context, data.familyStats!),
                            ],
                            const SizedBox(height: 32),
                            const _SectionTitle(
                              title: 'Global Leaderboard',
                              subtitle:
                                  'See top players and groups worldwide. Compete for the top spot!',
                            ),
                            const SizedBox(height: 12),
                            _buildLeaderboardSection(context),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressOverview(
    BuildContext context,
    PlayerProgress progress,
  ) {
    final xpNeeded = ProgressionConstants.xpNeededForNextLevel(progress.level);
    final progressValue =
        xpNeeded == 0 ? 0.0 : (progress.xpInLevel / xpNeeded).clamp(0.0, 1.0);
    final currentPhase =
        ProgressionConstants.phaseByIndex(progress.unlockedPhaseIndex);
    final nextPhase =
        progress.unlockedPhaseIndex + 1 < ProgressionConstants.phases.length
            ? ProgressionConstants.phaseByIndex(progress.unlockedPhaseIndex + 1)
            : null;
    final winsInPhase = progress.phaseWins[currentPhase.id] ?? 0;
    final perfectWins = progress.phasePerfectWins[currentPhase.id] ?? 0;
    final streak = progress.phaseStreaks[currentPhase.id] ?? 0;

    return Card(
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
                  '${progress.totalXp} XP',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Phase: ${currentPhase.title}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (nextPhase != null)
                  Chip(
                    avatar: const Icon(Icons.double_arrow,
                        size: 18, color: Colors.white),
                    label: Text('Next: ${nextPhase.title}',
                        style: const TextStyle(color: Colors.white)),
                    backgroundColor: AppColors.secondary,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progressValue,
              minHeight: 10,
              backgroundColor: AppColors.textSecondary.withValues(alpha: 0.2),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            const SizedBox(height: 8),
            Text(
              '${progress.xpInLevel} / $xpNeeded XP to next level',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Text(
              'Phase progress: $winsInPhase / ${currentPhase.requiredWins} wins'
              '${currentPhase.requiredPerfectWins > 0 ? ', $perfectWins / ${currentPhase.requiredPerfectWins} perfect' : ''}'
              '${currentPhase.requiredStreak > 0 ? ', streak $streak / ${currentPhase.requiredStreak}' : ''}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (nextPhase != null) ...[
              const SizedBox(height: 8),
              Text(
                'Next unlock: ${nextPhase.title} (requires ${currentPhase.requiredWins} wins${currentPhase.requiredPerfectWins > 0 ? ', ${currentPhase.requiredPerfectWins} perfect' : ''}${currentPhase.requiredStreak > 0 ? ', streak ${currentPhase.requiredStreak}' : ''})',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildStatChip(
                  icon: Icons.emoji_events,
                  label: 'Games',
                  value: '${progress.gamesPlayed}',
                ),
                _buildStatChip(
                  icon: Icons.star,
                  label: 'Perfect',
                  value: '${progress.perfectGames}',
                ),
                _buildStatChip(
                  icon: Icons.local_fire_department,
                  label: 'Streak',
                  value: '${progress.dailyStreak}',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPhaseGoalCard(
              context,
              currentPhase: currentPhase,
              nextPhase: nextPhase,
              wins: winsInPhase,
              perfectWins: perfectWins,
              streak: streak,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseGoalCard(
    BuildContext context, {
    required PhaseDefinition currentPhase,
    PhaseDefinition? nextPhase,
    required int wins,
    required int perfectWins,
    required int streak,
  }) {
    double ratio(int value, int required) {
      if (required <= 0) return 1;
      return (value / required).clamp(0.0, 1.0);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phase Goals',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (currentPhase.requiredWins > 0)
          _buildGoalProgress(
            context,
            label: 'Wins',
            value: wins,
            target: currentPhase.requiredWins,
            progress: ratio(wins, currentPhase.requiredWins),
          ),
        if (currentPhase.requiredPerfectWins > 0)
          _buildGoalProgress(
            context,
            label: 'Perfect Chains',
            value: perfectWins,
            target: currentPhase.requiredPerfectWins,
            progress: ratio(perfectWins, currentPhase.requiredPerfectWins),
          ),
        if (currentPhase.requiredStreak > 0)
          _buildGoalProgress(
            context,
            label: 'Streak',
            value: streak,
            target: currentPhase.requiredStreak,
            progress: ratio(streak, currentPhase.requiredStreak),
          ),
        if (nextPhase != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Next unlock: ${nextPhase.title} (up to ${nextPhase.maxLinks} links)',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  Widget _buildGoalProgress(
    BuildContext context, {
    required String label,
    required int value,
    required int target,
    required double progress,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text('$value / $target'),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: target == 0 ? 1 : progress,
            minHeight: 8,
            backgroundColor: AppColors.textSecondary.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyBanner(
    BuildContext context,
    DailyChallengeStatus status,
  ) {
    final completed = status.completedToday;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: completed
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            completed ? Icons.verified : Icons.bolt,
            color: completed ? AppColors.success : AppColors.warning,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  completed ? 'Daily streak alive!' : 'Daily challenge awaits!',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  completed
                      ? 'Current streak: ${status.streakCount} day(s)'
                      : 'Best score: ${status.bestScore}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildHeroSection(
    BuildContext context,
    _DashboardData data,
  ) {
    final completedToday = data.dailyStatus.completedToday;
    final heroText = completedToday
        ? 'Great run! Come back tomorrow for a fresh puzzle.'
        : 'Daily challenge is waiting. Keep your streak alive!';
    final buttonLabel =
        completedToday ? 'Play Guided Session' : 'Start Daily Challenge';
    final onTap = completedToday
        ? () => Navigator.pushNamed(
              context,
              AppConstants.routeGuided,
            )
        : _startDailyChallenge;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mystery Link',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            heroText,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryDark,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            icon: Icon(completedToday ? Icons.psychology : Icons.flash_on),
            label: Text(buttonLabel),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightPanel(
    BuildContext context,
    _DashboardData data,
    bool isWide,
  ) {
    return Flex(
      direction: isWide ? Axis.horizontal : Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildProgressOverview(context, data.progress),
        ),
        if (isWide) const SizedBox(width: 16) else const SizedBox(height: 16),
        Expanded(
          child: _buildDailyBanner(context, data.dailyStatus),
        ),
      ],
    );
  }

  Widget _buildNextMilestoneCard(
    BuildContext context, {
    required PlayerProgress progress,
  }) {
    final currentPhase =
        ProgressionConstants.phaseByIndex(progress.unlockedPhaseIndex);
    final wins = progress.phaseWins[currentPhase.id] ?? 0;
    final perfects = progress.phasePerfectWins[currentPhase.id] ?? 0;
    final streak = progress.phaseStreaks[currentPhase.id] ?? 0;

    String buildLine(String label, int current, int required) {
      if (required <= 0) return '';
      final remaining = (required - current).clamp(0, required);
      return remaining == 0 ? '$label: تم إنجازه!' : '$label: متبقي $remaining';
    }

    final lines = <String>[
      buildLine('عدد الانتصارات', wins, currentPhase.requiredWins),
      buildLine('سلاسل مثالية', perfects, currentPhase.requiredPerfectWins),
      buildLine('سلسلة متواصلة', streak, currentPhase.requiredStreak),
    ].where((line) => line.isNotEmpty).toList();

    return Card(
      elevation: 0,
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Phase: ${currentPhase.title}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (lines.isEmpty)
                  const Chip(
                    label: Text('Ready for next phase'),
                    avatar: Icon(Icons.check, size: 18, color: Colors.white),
                    backgroundColor: AppColors.success,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (lines.isEmpty)
              Text(
                AppLocalizations.of(context)!
                    .keepPlayingToMaintainProgress,
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final line in lines) ...[
                    Row(
                      children: [
                        const Icon(Icons.check_circle_outline, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(line)),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardSection(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: Future.wait([
        LeaderboardService().getTopPlayer(),
        LeaderboardService().getTopGroup(),
      ]).then((results) => {
            'topPlayer': results[0],
            'topGroup': results[1],
          }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error),
                  const SizedBox(height: 8),
                  Text(
                    'Failed to load leaderboard',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          );
        }

        final topPlayer = snapshot.data!['topPlayer'] as LeaderboardEntry?;
        final topGroup = snapshot.data!['topGroup'] as GroupLeaderboardEntry?;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppConstants.routeLeaderboard);
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.emoji_events,
                              color: AppColors.accent),
                          const SizedBox(width: 8),
                          Text(
                            'Global Rankings',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AppConstants.routeLeaderboard);
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Top Player
                  if (topPlayer != null)
                    _buildTopEntry(
                      context,
                      icon: Icons.person,
                      title: 'Top Player',
                      name: topPlayer.name,
                      score: topPlayer.score,
                      color: AppColors.accent,
                      subtitle: 'Global Champion',
                    ),

                  if (topPlayer != null && topGroup != null)
                    const SizedBox(height: 12),

                  // Top Group
                  if (topGroup != null)
                    _buildTopEntry(
                      context,
                      icon: Icons.people,
                      title: 'Top Group',
                      name: topGroup.name,
                      score: topGroup.totalScore,
                      color: AppColors.secondary,
                      subtitle: '${topGroup.memberCount} members',
                    ),

                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tap to see full rankings and compete for the top spot!',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.primary,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopEntry(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String name,
    required int score,
    required Color color,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$score',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              Text(
                'points',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildMiniStat(
  BuildContext context, {
  required String label,
  required String value,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        value,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
      Text(
        label,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}

String _relativeDate(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.inMinutes < 60) {
    final mins = diff.inMinutes;
    return mins <= 1 ? 'الآن' : '$mins دقيقة';
  } else if (diff.inHours < 24) {
    return '${diff.inHours} ساعة';
  }
  return '${diff.inDays} يوم';
}

class _HeaderRow extends StatelessWidget {
  final VoidCallback onSettingsPressed;

  const _HeaderRow({required this.onSettingsPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mystery Link',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Connect A to Z through rich, adaptive puzzles',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.settings_accessibility),
          tooltip: 'Accessibility & Language',
          onPressed: onSettingsPressed,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}

class _ModeBarRibbon extends StatelessWidget {
  final List<_ModeBarItem> items;

  const _ModeBarRibbon({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        return Padding(
          padding: EdgeInsets.only(top: index == 0 ? 0 : 12),
          child: _ModeBarStrip(
            item: item,
            isFirst: index == 0,
            isLast: index == items.length - 1,
          ),
        );
      }),
    );
  }
}

class _ModeBarItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _ModeBarItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _ModeBarStrip extends StatelessWidget {
  final _ModeBarItem item;
  final bool isFirst;
  final bool isLast;

  const _ModeBarStrip({
    required this.item,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.vertical(
      top: Radius.circular(isFirst ? 28 : 20),
      bottom: Radius.circular(isLast ? 28 : 20),
    );

    // استخدام نفس أسلوب الشريط العلوي تماماً - ألوان مباشرة وواضحة
    final baseColor = item.color;
    final darkColor = _getDarkVariantForMode(baseColor);
    // تدرج واضح وقوي مثل الشريط العلوي تماماً
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        baseColor,
        darkColor,
      ],
    );

    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: borderRadius,
          // نفس أسلوب الشريط العلوي تماماً - بدون أي شفافية إضافية
          boxShadow: [
            BoxShadow(
              color: baseColor.withValues(alpha: 0.3),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.25),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: Icon(
                item.icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardData {
  final PlayerProgress progress;
  final DailyChallengeStatus dailyStatus;
  final PhaseDefinition phase;
  final BrainGymStatus brainGymStatus;
  final FamilySessionStats? familyStats;
  final List<FuturePlaySuggestion> futureSuggestions;

  const _DashboardData(
    this.progress,
    this.dailyStatus,
    this.phase,
    this.brainGymStatus,
    this.familyStats,
    this.futureSuggestions,
  );
}

class FuturePlaySuggestion {
  final IconData icon;
  final String title;
  final String description;
  final String badge;
  final Color color;

  const FuturePlaySuggestion({
    required this.icon,
    required this.title,
    required this.description,
    required this.badge,
    required this.color,
  });
}

class _ThemeOptionChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _ThemeOptionChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}

class _FutureSuggestionTile extends StatelessWidget {
  final FuturePlaySuggestion suggestion;
  final bool enableMotion;

  const _FutureSuggestionTile({
    required this.suggestion,
    required this.enableMotion,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration:
          enableMotion ? const Duration(milliseconds: 300) : Duration.zero,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: suggestion.color.withValues(alpha: 0.08),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: suggestion.color.withValues(alpha: 0.2),
            child: Icon(suggestion.icon, color: suggestion.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        suggestion.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Chip(
                      label: Text(
                        suggestion.badge,
                        style: const TextStyle(fontSize: 10),
                      ),
                      backgroundColor: suggestion.color.withValues(alpha: 0.15),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  suggestion.description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension _ColorTone on Color {
  Color darken(double amount) {
    final hsl = HSLColor.fromColor(this);
    final newLight = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(newLight).toColor();
  }
}

/// الحصول على النسخة الداكنة من اللون حسب نوعه
/// مع ضمان وضوح أفضل - نفس أسلوب الشريط العلوي
Color _getDarkVariantForMode(Color color) {
  // استخدام الألوان المحددة مسبقاً مباشرة - مثل الشريط العلوي
  if (color == AppColors.modeSolo || color == AppColors.primary) {
    return AppColors.primaryDark;
  }
  if (color == AppColors.modeGroup || color == AppColors.secondary) {
    return AppColors.secondaryDark;
  }
  if (color == AppColors.modePractice || color == AppColors.accent) {
    return AppColors.accentDark;
  }
  if (color == AppColors.modeGuided || color == AppColors.info) {
    // للون info، استخدم نسخة أغمق واضحة
    return const Color(0xFF2563EB);
  }
  if (color == AppColors.modeDaily) {
    // للون daily، استخدم نسخة أغمق من البنفسجي
    return const Color(0xFF7C3AED);
  }

  // إذا لم يكن من الألوان المعرفة، استخدم darken بدرجة معتدلة
  return color.darken(0.2);
}
