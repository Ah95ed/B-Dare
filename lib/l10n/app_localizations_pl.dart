// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appName => 'Tajemnicze Połączenie';

  @override
  String get soloMode => 'Tryb Solo';

  @override
  String get groupMode => 'Tryb Grupowy';

  @override
  String get practiceMode => 'Tryb Treningowy';

  @override
  String get startGame => 'Rozpocznij Grę';

  @override
  String get selectDifficulty => 'Wybierz Poziom Trudności';

  @override
  String get selectRepresentation => 'Wybierz Typ Reprezentacji';

  @override
  String get text => 'Tekst';

  @override
  String get icon => 'Ikona';

  @override
  String get image => 'Obraz';

  @override
  String get event => 'Wydarzenie';

  @override
  String get links => 'Połączenia';

  @override
  String get timeRemaining => 'Pozostały Czas';

  @override
  String get step => 'Krok';

  @override
  String get ofLabel => 'z';

  @override
  String get correct => 'Poprawnie!';

  @override
  String get wrong => 'Niepoprawnie!';

  @override
  String get timeOut => 'Czas Minął!';

  @override
  String get score => 'Wynik';

  @override
  String get timeSpent => 'Spędzony Czas';

  @override
  String get correctChain => 'Poprawny Łańcuch';

  @override
  String get yourChoices => 'Twoje Wybory';

  @override
  String get playAgain => 'Zagraj Ponownie';

  @override
  String get share => 'Udostępnij';

  @override
  String get backToHome => 'Powrót do Strony Głównej';

  @override
  String get selectPlayers => 'Wybierz Liczbę Graczy';

  @override
  String get player => 'Gracz';

  @override
  String get points => 'Punkty';

  @override
  String get nextPlayer => 'Następny Gracz';

  @override
  String get gameOver => 'Koniec Gry';

  @override
  String get loading => 'Ładowanie...';

  @override
  String get error => 'Błąd';

  @override
  String get retry => 'Spróbuj Ponownie';

  @override
  String get perfectWin => 'Doskonale! Poprawnie ukończyłeś łańcuch!';

  @override
  String get timeUpMessage =>
      'Czas minął! Nie martw się, możesz spróbować ponownie.';

  @override
  String get tieMessage => 'Remis! Świetna gra, wszyscy!';

  @override
  String get helpText =>
      'Znajdź połączenie, które łączy aktualną kartę z celem. Pomyśl o relacji między nimi.';

  @override
  String get guidedModeHint =>
      'Przeczytaj podpowiedź przed wyborem: Szukaj połączenia, które łączy aktualną kartę z celem.';

  @override
  String get wellDone => 'Dobra robota!';

  @override
  String get keepTrying => 'Kontynuuj próby! Stajesz się lepszy!';

  @override
  String get excellent => 'Doskonale!';

  @override
  String get goodJob => 'Dobra robota!';

  @override
  String get almostThere => 'Prawie gotowe!';

  @override
  String get thinkAgain => 'Pomyśl ponownie. Co łączy te dwa?';

  @override
  String get accessibilityAndLanguage => 'Dostępność i Język';

  @override
  String get language => 'Język';

  @override
  String get textSize => 'Rozmiar Tekstu';

  @override
  String get themeMode => 'Tryb Motywu';

  @override
  String get systemTheme => 'System';

  @override
  String get lightThemeOption => 'Jasny';

  @override
  String get darkThemeOption => 'Ciemny';

  @override
  String get dynamicColors => 'Dynamiczne Kolory';

  @override
  String get dynamicColorsSubtitle =>
      'Połącz interfejs z adaptacyjnymi gradientami i podświetleniami.';

  @override
  String get motionEffects => 'Ruch i Animacje';

  @override
  String get motionEffectsSubtitle =>
      'Wyłącz animacje, jeśli preferujesz spokojniejszy interfejs.';

  @override
  String get liveTournamentFeed => 'Na Żywo Kanał Turniejowy';

  @override
  String get liveTournamentFeedEmpty =>
      'Na żywo drabinki i iskry meczów pojawią się tutaj, gdy turnieje się rozpoczną.';

  @override
  String get futurePlaybook => 'Przyszłościowy Playbook';

  @override
  String get futurePlaybookSubtitle =>
      'Nadchodzące trendy przygotowane na następną dekadę';

  @override
  String get levelsChallenges => 'Poziomy i Wyzwania';

  @override
  String get levelsChallengesSubtitle =>
      'Przeglądaj ustrukturyzowane poziomy i ich wyzwania';

  @override
  String get close => 'Zamknij';

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
