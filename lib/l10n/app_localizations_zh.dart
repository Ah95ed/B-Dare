// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => '神秘链接';

  @override
  String get soloMode => '单人模式';

  @override
  String get groupMode => '团队模式';

  @override
  String get practiceMode => '练习模式';

  @override
  String get startGame => '开始游戏';

  @override
  String get selectDifficulty => '选择难度';

  @override
  String get selectRepresentation => '选择表示类型';

  @override
  String get text => '文本';

  @override
  String get icon => '图标';

  @override
  String get image => '图片';

  @override
  String get event => '事件';

  @override
  String get links => '链接';

  @override
  String get timeRemaining => '剩余时间';

  @override
  String get step => '步骤';

  @override
  String get ofLabel => '的';

  @override
  String get correct => '正确！';

  @override
  String get wrong => '错误！';

  @override
  String get timeOut => '时间到！';

  @override
  String get score => '分数';

  @override
  String get timeSpent => '用时';

  @override
  String get correctChain => '正确链';

  @override
  String get yourChoices => '您的选择';

  @override
  String get playAgain => '再玩一次';

  @override
  String get share => '分享';

  @override
  String get backToHome => '返回首页';

  @override
  String get selectPlayers => '选择玩家数量';

  @override
  String get player => '玩家';

  @override
  String get points => '分数';

  @override
  String get nextPlayer => '下一位玩家';

  @override
  String get gameOver => '游戏结束';

  @override
  String get loading => '加载中...';

  @override
  String get error => '错误';

  @override
  String get retry => '重试';

  @override
  String get perfectWin => '完美！您正确地完成了链接！';

  @override
  String get timeUpMessage => '时间到了！别担心，您可以再试一次。';

  @override
  String get tieMessage => '平局！大家都很棒！';

  @override
  String get helpText => '找到连接当前卡片到目标的链接。思考它们之间的关系。';

  @override
  String get guidedModeHint => '在选择前阅读提示：寻找连接当前卡片到目标的链接。';

  @override
  String get wellDone => '做得好！';

  @override
  String get keepTrying => '继续努力！您正在进步！';

  @override
  String get excellent => '优秀！';

  @override
  String get goodJob => '干得好！';

  @override
  String get almostThere => '快到了！';

  @override
  String get thinkAgain => '再想想。什么连接了这两个？';

  @override
  String get accessibilityAndLanguage => '无障碍与语言';

  @override
  String get language => '语言';

  @override
  String get textSize => '文字大小';

  @override
  String get themeMode => '主题模式';

  @override
  String get systemTheme => '系统';

  @override
  String get lightThemeOption => '浅色';

  @override
  String get darkThemeOption => '深色';

  @override
  String get dynamicColors => '动态颜色';

  @override
  String get dynamicColorsSubtitle => '使用自适应渐变和高光混合界面。';

  @override
  String get motionEffects => '动效与动画';

  @override
  String get motionEffectsSubtitle => '如果您喜欢更平静的界面，可以禁用动画。';

  @override
  String get liveTournamentFeed => '实时锦标赛动态';

  @override
  String get liveTournamentFeedEmpty => '锦标赛开始后，实时赛程和比赛动态将显示在这里。';

  @override
  String get futurePlaybook => '未来手册';

  @override
  String get futurePlaybookSubtitle => '为未来十年准备的即将到来的趋势';

  @override
  String get levelsChallenges => '关卡与挑战';

  @override
  String get levelsChallengesSubtitle => '浏览结构化关卡及其挑战';

  @override
  String get close => '关闭';

  @override
  String dailySessionStatusCompleted(int streak) {
    return 'You finished today’s session! $streak day streak';
  }

  @override
  String dailySessionStatusNotStarted(int streak) {
    return 'You haven’t started today’s session yet · Current streak: $streak days';
  }

  @override
  String dailySessionTotalSessions(int count) {
    return 'Total sessions: $count';
  }

  @override
  String get brainGymStartNow => 'Start Brain Gym now';

  @override
  String familySessionsTitleWithProfile(String profile) {
    return '$profile sessions';
  }

  @override
  String get familySessionsTitleDefault => 'Family sessions';

  @override
  String get sessionsLabel => 'Sessions';

  @override
  String get winsLabel => 'Wins';

  @override
  String get lastSessionLabel => 'Last session';

  @override
  String familyWeeklyGoal(int wins) {
    return 'This week’s goal: win 3 family sessions. Current progress $wins/3.';
  }

  @override
  String familyWinsSessionsSummary(int wins, int sessions) {
    return 'Wins: $wins / Sessions: $sessions';
  }

  @override
  String get familyNoSessionYet => 'Start your first family session today!';

  @override
  String get familyStartNewSession => 'Start new session';

  @override
  String get keepPlayingToMaintainProgress =>
      'Keep playing to maintain your progress!';

  @override
  String get guidedModeTitle => 'Guided Mode';

  @override
  String get guidedModeDescription =>
      'Simplified steps and hints for younger players and beginners.';

  @override
  String get soloModeDescription => 'Play alone and challenge yourself';

  @override
  String get createGroupTitle => 'Create Group';

  @override
  String get createGroupDescription => 'Create a group game with friends';

  @override
  String get globalTournamentsTitle => 'Global Tournaments';

  @override
  String get globalTournamentsDescription =>
      'Join global tournaments and become world champion';

  @override
  String get progressKeepPlayingHint => 'Keep playing to keep your momentum!';

  @override
  String get brainGymSessionCompletedFinal =>
      '🎯 You finished your Brain Gym session!';

  @override
  String get brainGymPerfectRoundHeadline => '💪 Perfect round!';

  @override
  String get brainGymNewRoundHeadline => 'Great! New Brain Gym round';

  @override
  String brainGymCurrentStreak(int streak) {
    return 'Your current streak: $streak days';
  }

  @override
  String get brainGymStartNewStreak => 'Start a new streak today';

  @override
  String brainGymRoundProgress(int current, int total, int score) {
    return 'Round $current of $total · Session score: $score';
  }

  @override
  String brainGymTotalSessions(int total) {
    return 'Total training sessions: $total';
  }

  @override
  String get guidedModeIntroStep1 =>
      'Listen to the short instructions, then read the start and end points.';

  @override
  String get guidedModeIntroStep2 =>
      'Choose the correct link from three simplified options.';

  @override
  String get guidedModeIntroStep3 =>
      'If you make a mistake, you will get an instant hint to help next time.';

  @override
  String get guidedModeLongDescription =>
      'An experience suitable for younger players and new users. This mode focuses on short chains with visual and audio hints.';

  @override
  String get guidedModeStartSession => 'Start guided session';

  @override
  String get selectGameTypeTitle => 'Choose game type';

  @override
  String familySessionTitleWithProfileInGame(String profile) {
    return '$profile team';
  }

  @override
  String get familySessionTitleInGame => 'Family session';

  @override
  String get sessionsShortLabel => 'Sessions';

  @override
  String get winsShortLabel => 'Wins';

  @override
  String get lossesShortLabel => 'Losses';

  @override
  String get lastSessionShort => 'Last session';

  @override
  String relativeMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String relativeHours(int hours) {
    return '$hours h';
  }

  @override
  String relativeDays(int days) {
    return '$days d';
  }

  @override
  String get matchNotReady => 'Match is not ready yet';

  @override
  String matchStartFailed(String error) {
    return 'Failed to start match: $error';
  }

  @override
  String matchJoinFailed(String error) {
    return 'Failed to join match: $error';
  }

  @override
  String get tournamentGlobalTitle => 'Global Tournaments';

  @override
  String get tournamentNoTournaments => 'No tournaments';

  @override
  String get tournamentFilterLabel => 'Filter:';

  @override
  String get tournamentFilterAll => 'All';

  @override
  String get tournamentFilterRegistration => 'Registration';

  @override
  String get tournamentFilterQualifiers => 'Qualifiers';

  @override
  String get tournamentFilterFinal => 'Final';

  @override
  String get tournamentFilterCompleted => 'Completed';

  @override
  String get tournamentEmptyTitle => 'No tournaments at the moment';

  @override
  String get tournamentCreateNew => 'Create new tournament';

  @override
  String get tournamentStagesSectionTitle => 'Stages';

  @override
  String tournamentTeamsSectionTitle(int count, int max) {
    return 'Teams ($count/$max)';
  }

  @override
  String tournamentViewAllTeams(int count) {
    return 'View all teams ($count)';
  }

  @override
  String get tournamentBracketTitle => 'Bracket';

  @override
  String get tournamentBracketUnavailable => 'Bracket is not available yet';

  @override
  String get tournamentViewBracket => 'View bracket';

  @override
  String get tournamentStart => 'Start tournament';

  @override
  String get back => 'Back';

  @override
  String get tournamentStatusRegistration => 'Registration';

  @override
  String get tournamentStatusQualifiers => 'Qualifiers';

  @override
  String get tournamentStatusPlayoffs => 'Playoffs';

  @override
  String get tournamentStatusFinal => 'Final';

  @override
  String get tournamentStatusCompleted => 'Completed';

  @override
  String get tournamentStatusCancelled => 'Cancelled';

  @override
  String get tournamentMatchStatusScheduled => 'Scheduled';

  @override
  String get tournamentMatchStatusInProgress => 'In progress';

  @override
  String get tournamentMatchStatusCompleted => 'Completed';

  @override
  String get tournamentMatchStatusForfeit => 'Forfeit';

  @override
  String get tournamentMatchStatusCancelled => 'Cancelled';

  @override
  String get tournamentStatsTeams => 'Teams';

  @override
  String get tournamentStatsStages => 'Stages';

  @override
  String get tournamentStatsType => 'Type';

  @override
  String get tournamentTypeSingleElimination => 'Single Elimination';

  @override
  String get tournamentTypeDoubleElimination => 'Double Elimination';

  @override
  String get tournamentTypeSwiss => 'Swiss';

  @override
  String get tournamentTypeRoundRobin => 'Round Robin';

  @override
  String stageRoundProgress(int current, int total) {
    return 'Round $current/$total';
  }

  @override
  String get matchesLabel => 'Matches';

  @override
  String get stageStatusNotStarted => 'Not started';

  @override
  String get stageStatusInProgress => 'In progress';

  @override
  String get stageStatusCompleted => 'Completed';

  @override
  String relativeInDays(int days) {
    return 'In $days days';
  }

  @override
  String relativeInHours(int hours) {
    return 'In $hours hours';
  }

  @override
  String relativeInMinutes(int minutes) {
    return 'In $minutes minutes';
  }

  @override
  String get relativeStarted => 'Started';

  @override
  String get relativeNow => 'Now';

  @override
  String get matchTitle => 'Match';

  @override
  String get matchStart => 'Start match';

  @override
  String get matchJoin => 'Join match';

  @override
  String get samplePuzzleLoaded => 'Loaded a practice puzzle';
}
