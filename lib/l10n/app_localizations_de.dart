// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Mystery Link';

  @override
  String get soloMode => 'Einzelspieler-Modus';

  @override
  String get groupMode => 'Gruppenmodus';

  @override
  String get practiceMode => 'Übungsmodus';

  @override
  String get startGame => 'Spiel starten';

  @override
  String get selectDifficulty => 'Schwierigkeit auswählen';

  @override
  String get selectRepresentation => 'Darstellungstyp auswählen';

  @override
  String get text => 'Text';

  @override
  String get icon => 'Symbol';

  @override
  String get image => 'Bild';

  @override
  String get event => 'Ereignis';

  @override
  String get links => 'Verknüpfungen';

  @override
  String get timeRemaining => 'Verbleibende Zeit';

  @override
  String get step => 'Schritt';

  @override
  String get ofLabel => 'von';

  @override
  String get correct => 'Richtig!';

  @override
  String get wrong => 'Falsch!';

  @override
  String get timeOut => 'Zeit abgelaufen!';

  @override
  String get score => 'Punkte';

  @override
  String get timeSpent => 'Verbrauchte Zeit';

  @override
  String get correctChain => 'Richtige Kette';

  @override
  String get yourChoices => 'Ihre Auswahl';

  @override
  String get playAgain => 'Nochmal spielen';

  @override
  String get share => 'Teilen';

  @override
  String get backToHome => 'Zurück zum Start';

  @override
  String get selectPlayers => 'Anzahl der Spieler auswählen';

  @override
  String get player => 'Spieler';

  @override
  String get points => 'Punkte';

  @override
  String get nextPlayer => 'Nächster Spieler';

  @override
  String get gameOver => 'Spiel beendet';

  @override
  String get loading => 'Lädt...';

  @override
  String get error => 'Fehler';

  @override
  String get retry => 'Wiederholen';

  @override
  String get perfectWin =>
      'Perfekt! Sie haben die Kette korrekt abgeschlossen!';

  @override
  String get timeUpMessage =>
      'Die Zeit ist abgelaufen! Keine Sorge, Sie können es erneut versuchen.';

  @override
  String get tieMessage => 'Unentschieden! Großartiges Spiel, alle!';

  @override
  String get helpText =>
      'Finden Sie die Verknüpfung, die die aktuelle Karte mit dem Ziel verbindet. Denken Sie über die Beziehung zwischen ihnen nach.';

  @override
  String get guidedModeHint =>
      'Lesen Sie den Hinweis vor der Auswahl: Suchen Sie nach der Verknüpfung, die die aktuelle Karte mit dem Ziel verbindet.';

  @override
  String get wellDone => 'Gut gemacht!';

  @override
  String get keepTrying => 'Weiter so! Sie werden besser!';

  @override
  String get excellent => 'Ausgezeichnet!';

  @override
  String get goodJob => 'Gute Arbeit!';

  @override
  String get almostThere => 'Fast geschafft!';

  @override
  String get thinkAgain =>
      'Denken Sie noch einmal nach. Was verbindet diese beiden?';

  @override
  String get accessibilityAndLanguage => 'Barrierefreiheit und Sprache';

  @override
  String get language => 'Sprache';

  @override
  String get textSize => 'Textgröße';

  @override
  String get themeMode => 'Themenmodus';

  @override
  String get systemTheme => 'System';

  @override
  String get lightThemeOption => 'Hell';

  @override
  String get darkThemeOption => 'Dunkel';

  @override
  String get dynamicColors => 'Dynamische Farben';

  @override
  String get dynamicColorsSubtitle =>
      'Mischen Sie die Oberfläche mit adaptiven Verläufen und Hervorhebungen.';

  @override
  String get motionEffects => 'Bewegung und Animationen';

  @override
  String get motionEffectsSubtitle =>
      'Deaktivieren Sie Animationen, wenn Sie eine ruhigere Benutzeroberfläche bevorzugen.';

  @override
  String get liveTournamentFeed => 'Live-Turnier-Feed';

  @override
  String get liveTournamentFeedEmpty =>
      'Live-Brackets und Match-Funken erscheinen hier, sobald Turniere beginnen.';

  @override
  String get futurePlaybook => 'Zukunfts-Playbook';

  @override
  String get futurePlaybookSubtitle =>
      'Kommende Trends für das nächste Jahrzehnt vorbereitet';

  @override
  String get levelsChallenges => 'Levels und Herausforderungen';

  @override
  String get levelsChallengesSubtitle =>
      'Durchsuchen Sie strukturierte Levels und ihre Herausforderungen';

  @override
  String get close => 'Schließen';

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
