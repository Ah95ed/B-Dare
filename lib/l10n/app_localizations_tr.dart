// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Gizemli Bağlantı';

  @override
  String get soloMode => 'Tekli Mod';

  @override
  String get groupMode => 'Grup Modu';

  @override
  String get practiceMode => 'Pratik Modu';

  @override
  String get startGame => 'Oyunu Başlat';

  @override
  String get selectDifficulty => 'Zorluk Seç';

  @override
  String get selectRepresentation => 'Temsil Türünü Seç';

  @override
  String get text => 'Metin';

  @override
  String get icon => 'Simge';

  @override
  String get image => 'Görsel';

  @override
  String get event => 'Etkinlik';

  @override
  String get links => 'Bağlantılar';

  @override
  String get timeRemaining => 'Kalan Süre';

  @override
  String get step => 'Adım';

  @override
  String get ofLabel => 'nin';

  @override
  String get correct => 'Doğru!';

  @override
  String get wrong => 'Yanlış!';

  @override
  String get timeOut => 'Süre Doldu!';

  @override
  String get score => 'Puan';

  @override
  String get timeSpent => 'Harcanan Süre';

  @override
  String get correctChain => 'Doğru Zincir';

  @override
  String get yourChoices => 'Seçimleriniz';

  @override
  String get playAgain => 'Tekrar Oyna';

  @override
  String get share => 'Paylaş';

  @override
  String get backToHome => 'Ana Sayfaya Dön';

  @override
  String get selectPlayers => 'Oyuncu Sayısını Seç';

  @override
  String get player => 'Oyuncu';

  @override
  String get points => 'Puan';

  @override
  String get nextPlayer => 'Sonraki Oyuncu';

  @override
  String get gameOver => 'Oyun Bitti';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get error => 'Hata';

  @override
  String get retry => 'Yeniden Dene';

  @override
  String get perfectWin => 'Mükemmel! Zinciri doğru şekilde tamamladınız!';

  @override
  String get timeUpMessage =>
      'Süre doldu! Endişelenmeyin, tekrar deneyebilirsiniz.';

  @override
  String get tieMessage => 'Berabere! Herkese harika oyun!';

  @override
  String get helpText =>
      'Mevcut kartı hedefe bağlayan bağlantıyı bulun. Aralarındaki ilişkiyi düşünün.';

  @override
  String get guidedModeHint =>
      'Seçmeden önce ipucunu okuyun: Mevcut kartı hedefe bağlayan bağlantıyı arayın.';

  @override
  String get wellDone => 'Aferin!';

  @override
  String get keepTrying => 'Denemeye devam edin! Daha iyi oluyorsunuz!';

  @override
  String get excellent => 'Mükemmel!';

  @override
  String get goodJob => 'İyi iş!';

  @override
  String get almostThere => 'Neredeyse tamam!';

  @override
  String get thinkAgain => 'Tekrar düşünün. Bu ikisini ne bağlar?';

  @override
  String get accessibilityAndLanguage => 'Erişilebilirlik ve Dil';

  @override
  String get language => 'Dil';

  @override
  String get textSize => 'Metin Boyutu';

  @override
  String get themeMode => 'Tema Modu';

  @override
  String get systemTheme => 'Sistem';

  @override
  String get lightThemeOption => 'Açık';

  @override
  String get darkThemeOption => 'Koyu';

  @override
  String get dynamicColors => 'Dinamik Renkler';

  @override
  String get dynamicColorsSubtitle =>
      'Arayüzü uyarlanabilir gradyanlar ve vurgularla karıştırın.';

  @override
  String get motionEffects => 'Hareket ve Animasyonlar';

  @override
  String get motionEffectsSubtitle =>
      'Daha sakin bir arayüz tercih ediyorsanız animasyonları devre dışı bırakın.';

  @override
  String get liveTournamentFeed => 'Canlı Turnuva Akışı';

  @override
  String get liveTournamentFeedEmpty =>
      'Turnuvalar başladığında canlı eşleşmeler ve maç kıvılcımları burada görünecek.';

  @override
  String get futurePlaybook => 'Gelecek Oyun Kitabı';

  @override
  String get futurePlaybookSubtitle =>
      'Önümüzdeki on yıl için hazırlanan yaklaşan trendler';

  @override
  String get levelsChallenges => 'Seviyeler ve Zorluklar';

  @override
  String get levelsChallengesSubtitle =>
      'Yapılandırılmış seviyeleri ve zorluklarını gözden geçirin';

  @override
  String get close => 'Kapat';

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
