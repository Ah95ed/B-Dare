// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'Mystery Link';

  @override
  String get soloMode => 'Modalità Singola';

  @override
  String get groupMode => 'Modalità Gruppo';

  @override
  String get practiceMode => 'Modalità Pratica';

  @override
  String get startGame => 'Inizia Gioco';

  @override
  String get selectDifficulty => 'Seleziona Difficoltà';

  @override
  String get selectRepresentation => 'Seleziona Tipo di Rappresentazione';

  @override
  String get text => 'Testo';

  @override
  String get icon => 'Icona';

  @override
  String get image => 'Immagine';

  @override
  String get event => 'Evento';

  @override
  String get links => 'Collegamenti';

  @override
  String get timeRemaining => 'Tempo Rimanente';

  @override
  String get step => 'Passo';

  @override
  String get ofLabel => 'di';

  @override
  String get correct => 'Corretto!';

  @override
  String get wrong => 'Sbagliato!';

  @override
  String get timeOut => 'Tempo Scaduto!';

  @override
  String get score => 'Punteggio';

  @override
  String get timeSpent => 'Tempo Impiegato';

  @override
  String get correctChain => 'Catena Corretta';

  @override
  String get yourChoices => 'Le Tue Scelte';

  @override
  String get playAgain => 'Gioca di Nuovo';

  @override
  String get share => 'Condividi';

  @override
  String get backToHome => 'Torna alla Home';

  @override
  String get selectPlayers => 'Seleziona Numero di Giocatori';

  @override
  String get player => 'Giocatore';

  @override
  String get points => 'Punti';

  @override
  String get nextPlayer => 'Prossimo Giocatore';

  @override
  String get gameOver => 'Gioco Finito';

  @override
  String get loading => 'Caricamento...';

  @override
  String get error => 'Errore';

  @override
  String get retry => 'Riprova';

  @override
  String get perfectWin => 'Perfetto! Hai completato la catena correttamente!';

  @override
  String get timeUpMessage =>
      'Tempo scaduto! Non preoccuparti, puoi riprovare.';

  @override
  String get tieMessage => 'Pareggio! Ottimo gioco a tutti!';

  @override
  String get helpText =>
      'Trova il collegamento che connette la carta corrente all\'obiettivo. Pensa alla relazione tra loro.';

  @override
  String get guidedModeHint =>
      'Leggi il suggerimento prima di scegliere: Cerca il collegamento che connette la carta corrente all\'obiettivo.';

  @override
  String get wellDone => 'Ben fatto!';

  @override
  String get keepTrying => 'Continua a provare! Stai migliorando!';

  @override
  String get excellent => 'Eccellente!';

  @override
  String get goodJob => 'Ottimo lavoro!';

  @override
  String get almostThere => 'Quasi ci sei!';

  @override
  String get thinkAgain => 'Ripensa. Cosa collega questi due?';

  @override
  String get accessibilityAndLanguage => 'Accessibilità e Lingua';

  @override
  String get language => 'Lingua';

  @override
  String get textSize => 'Dimensione Testo';

  @override
  String get themeMode => 'Modalità Tema';

  @override
  String get systemTheme => 'Sistema';

  @override
  String get lightThemeOption => 'Chiaro';

  @override
  String get darkThemeOption => 'Scuro';

  @override
  String get dynamicColors => 'Colori Dinamici';

  @override
  String get dynamicColorsSubtitle =>
      'Miscela l\'interfaccia con gradienti e evidenziazioni adattive.';

  @override
  String get motionEffects => 'Movimento e Animazioni';

  @override
  String get motionEffectsSubtitle =>
      'Disabilita le animazioni se preferisci un\'interfaccia più calma.';

  @override
  String get liveTournamentFeed => 'Feed Torneo in Diretta';

  @override
  String get liveTournamentFeedEmpty =>
      'Tabelloni in diretta e scintille di partite appariranno qui una volta che i tornei inizieranno.';

  @override
  String get futurePlaybook => 'Playbook del Futuro';

  @override
  String get futurePlaybookSubtitle =>
      'Tendenze future preparate per il prossimo decennio';

  @override
  String get levelsChallenges => 'Livelli e Sfide';

  @override
  String get levelsChallengesSubtitle =>
      'Sfoglia livelli strutturati e le loro sfide';

  @override
  String get close => 'Chiudi';

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
