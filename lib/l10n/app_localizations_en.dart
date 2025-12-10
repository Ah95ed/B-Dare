// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Mystery Link';

  @override
  String get soloMode => 'Solo Mode';

  @override
  String get groupMode => 'Group Mode';

  @override
  String get practiceMode => 'Practice Mode';

  @override
  String get startGame => 'Start Game';

  @override
  String get selectDifficulty => 'Select Difficulty';

  @override
  String get selectRepresentation => 'Select Representation Type';

  @override
  String get text => 'Text';

  @override
  String get icon => 'Icon';

  @override
  String get image => 'Image';

  @override
  String get event => 'Event';

  @override
  String get links => 'Links';

  @override
  String get timeRemaining => 'Time Remaining';

  @override
  String get step => 'Step';

  @override
  String get ofLabel => 'of';

  @override
  String get correct => 'Correct!';

  @override
  String get wrong => 'Wrong!';

  @override
  String get timeOut => 'Time\'s Up!';

  @override
  String get score => 'Score';

  @override
  String get timeSpent => 'Time Spent';

  @override
  String get correctChain => 'Correct Chain';

  @override
  String get yourChoices => 'Your Choices';

  @override
  String get playAgain => 'Play Again';

  @override
  String get share => 'Share';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get selectPlayers => 'Select Number of Players';

  @override
  String get player => 'Player';

  @override
  String get points => 'Points';

  @override
  String get nextPlayer => 'Next Player';

  @override
  String get gameOver => 'Game Over';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get perfectWin => 'Perfect! You completed the chain correctly!';

  @override
  String get timeUpMessage => 'Time\'s up! Don\'t worry, you can try again.';

  @override
  String get tieMessage => 'It\'s a tie! Great game everyone!';

  @override
  String get helpText =>
      'Find the link that connects the current card to the goal. Think about the relationship between them.';

  @override
  String get guidedModeHint =>
      'Read the hint before choosing: Look for the link that connects the current card to the target.';

  @override
  String get wellDone => 'Well done!';

  @override
  String get keepTrying => 'Keep trying! You\'re getting better!';

  @override
  String get excellent => 'Excellent!';

  @override
  String get goodJob => 'Good job!';

  @override
  String get almostThere => 'Almost there!';

  @override
  String get thinkAgain => 'Think again. What connects these two?';

  @override
  String get accessibilityAndLanguage => 'Accessibility & Language';

  @override
  String get language => 'Language';

  @override
  String get textSize => 'Text Size';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get systemTheme => 'System';

  @override
  String get lightThemeOption => 'Light';

  @override
  String get darkThemeOption => 'Dark';

  @override
  String get dynamicColors => 'Dynamic Colors';

  @override
  String get dynamicColorsSubtitle =>
      'Blend the interface with adaptive gradients and highlights.';

  @override
  String get motionEffects => 'Motion & Animations';

  @override
  String get motionEffectsSubtitle =>
      'Disable animations if you prefer a calmer UI.';

  @override
  String get liveTournamentFeed => 'Live Tournament Feed';

  @override
  String get liveTournamentFeedEmpty =>
      'Live brackets and match sparks will appear here once tournaments start.';

  @override
  String get futurePlaybook => 'Future Playbook';

  @override
  String get futurePlaybookSubtitle =>
      'Upcoming trends prepared for the next decade';

  @override
  String get levelsChallenges => 'Levels & Challenges';

  @override
  String get levelsChallengesSubtitle =>
      'Browse structured levels and their challenges';

  @override
  String get close => 'Close';

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
