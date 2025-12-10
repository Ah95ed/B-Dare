// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'रहस्य लिंक';

  @override
  String get soloMode => 'एकल मोड';

  @override
  String get groupMode => 'समूह मोड';

  @override
  String get practiceMode => 'अभ्यास मोड';

  @override
  String get startGame => 'खेल शुरू करें';

  @override
  String get selectDifficulty => 'कठिनाई चुनें';

  @override
  String get selectRepresentation => 'प्रतिनिधित्व प्रकार चुनें';

  @override
  String get text => 'पाठ';

  @override
  String get icon => 'आइकन';

  @override
  String get image => 'छवि';

  @override
  String get event => 'घटना';

  @override
  String get links => 'लिंक';

  @override
  String get timeRemaining => 'शेष समय';

  @override
  String get step => 'चरण';

  @override
  String get ofLabel => 'का';

  @override
  String get correct => 'सही!';

  @override
  String get wrong => 'गलत!';

  @override
  String get timeOut => 'समय समाप्त!';

  @override
  String get score => 'स्कोर';

  @override
  String get timeSpent => 'बिताया गया समय';

  @override
  String get correctChain => 'सही श्रृंखला';

  @override
  String get yourChoices => 'आपकी पसंद';

  @override
  String get playAgain => 'फिर से खेलें';

  @override
  String get share => 'साझा करें';

  @override
  String get backToHome => 'होम पर वापस जाएं';

  @override
  String get selectPlayers => 'खिलाड़ियों की संख्या चुनें';

  @override
  String get player => 'खिलाड़ी';

  @override
  String get points => 'अंक';

  @override
  String get nextPlayer => 'अगला खिलाड़ी';

  @override
  String get gameOver => 'खेल समाप्त';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get error => 'त्रुटि';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get perfectWin =>
      'बिल्कुल सही! आपने श्रृंखला को सही तरीके से पूरा किया!';

  @override
  String get timeUpMessage =>
      'समय समाप्त हो गया! चिंता न करें, आप फिर से कोशिश कर सकते हैं।';

  @override
  String get tieMessage => 'यह बराबरी है! सभी को बहुत बढ़िया खेल!';

  @override
  String get helpText =>
      'वर्तमान कार्ड को लक्ष्य से जोड़ने वाला लिंक खोजें। उनके बीच के संबंध के बारे में सोचें।';

  @override
  String get guidedModeHint =>
      'चुनने से पहले संकेत पढ़ें: वर्तमान कार्ड को लक्ष्य से जोड़ने वाला लिंक खोजें।';

  @override
  String get wellDone => 'बहुत बढ़िया!';

  @override
  String get keepTrying => 'कोशिश जारी रखें! आप बेहतर हो रहे हैं!';

  @override
  String get excellent => 'उत्कृष्ट!';

  @override
  String get goodJob => 'अच्छा काम!';

  @override
  String get almostThere => 'लगभग वहाँ!';

  @override
  String get thinkAgain => 'फिर से सोचें। इन दोनों को क्या जोड़ता है?';

  @override
  String get accessibilityAndLanguage => 'पहुंच और भाषा';

  @override
  String get language => 'भाषा';

  @override
  String get textSize => 'पाठ आकार';

  @override
  String get themeMode => 'थीम मोड';

  @override
  String get systemTheme => 'सिस्टम';

  @override
  String get lightThemeOption => 'हल्का';

  @override
  String get darkThemeOption => 'गहरा';

  @override
  String get dynamicColors => 'गतिशील रंग';

  @override
  String get dynamicColorsSubtitle =>
      'अनुकूली ग्रेडिएंट और हाइलाइट्स के साथ इंटरफेस को मिलाएं।';

  @override
  String get motionEffects => 'गति और एनिमेशन';

  @override
  String get motionEffectsSubtitle =>
      'यदि आप शांत UI पसंद करते हैं तो एनिमेशन अक्षम करें।';

  @override
  String get liveTournamentFeed => 'लाइव टूर्नामेंट फीड';

  @override
  String get liveTournamentFeedEmpty =>
      'टूर्नामेंट शुरू होने के बाद लाइव ब्रैकेट और मैच स्पार्क यहां दिखाई देंगे।';

  @override
  String get futurePlaybook => 'भविष्य प्लेबुक';

  @override
  String get futurePlaybookSubtitle => 'अगले दशक के लिए तैयार आने वाले रुझान';

  @override
  String get levelsChallenges => 'स्तर और चुनौतियां';

  @override
  String get levelsChallengesSubtitle =>
      'संरचित स्तर और उनकी चुनौतियां ब्राउज़ करें';

  @override
  String get close => 'बंद करें';

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
