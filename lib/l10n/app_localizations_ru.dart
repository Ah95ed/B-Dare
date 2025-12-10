// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Тайная Связь';

  @override
  String get soloMode => 'Одиночный режим';

  @override
  String get groupMode => 'Групповой режим';

  @override
  String get practiceMode => 'Режим практики';

  @override
  String get startGame => 'Начать игру';

  @override
  String get selectDifficulty => 'Выбрать сложность';

  @override
  String get selectRepresentation => 'Выбрать тип представления';

  @override
  String get text => 'Текст';

  @override
  String get icon => 'Иконка';

  @override
  String get image => 'Изображение';

  @override
  String get event => 'Событие';

  @override
  String get links => 'Связи';

  @override
  String get timeRemaining => 'Оставшееся время';

  @override
  String get step => 'Шаг';

  @override
  String get ofLabel => 'из';

  @override
  String get correct => 'Правильно!';

  @override
  String get wrong => 'Неправильно!';

  @override
  String get timeOut => 'Время вышло!';

  @override
  String get score => 'Счёт';

  @override
  String get timeSpent => 'Затраченное время';

  @override
  String get correctChain => 'Правильная цепочка';

  @override
  String get yourChoices => 'Ваши выборы';

  @override
  String get playAgain => 'Играть снова';

  @override
  String get share => 'Поделиться';

  @override
  String get backToHome => 'Вернуться на главную';

  @override
  String get selectPlayers => 'Выбрать количество игроков';

  @override
  String get player => 'Игрок';

  @override
  String get points => 'Очки';

  @override
  String get nextPlayer => 'Следующий игрок';

  @override
  String get gameOver => 'Игра окончена';

  @override
  String get loading => 'Загрузка...';

  @override
  String get error => 'Ошибка';

  @override
  String get retry => 'Повторить';

  @override
  String get perfectWin => 'Отлично! Вы правильно завершили цепочку!';

  @override
  String get timeUpMessage =>
      'Время вышло! Не волнуйтесь, вы можете попробовать снова.';

  @override
  String get tieMessage => 'Ничья! Отличная игра, все!';

  @override
  String get helpText =>
      'Найдите связь, которая соединяет текущую карту с целью. Подумайте о связи между ними.';

  @override
  String get guidedModeHint =>
      'Прочитайте подсказку перед выбором: Ищите связь, которая соединяет текущую карту с целью.';

  @override
  String get wellDone => 'Отлично!';

  @override
  String get keepTrying => 'Продолжайте попытки! Вы становитесь лучше!';

  @override
  String get excellent => 'Превосходно!';

  @override
  String get goodJob => 'Хорошая работа!';

  @override
  String get almostThere => 'Почти готово!';

  @override
  String get thinkAgain => 'Подумайте ещё раз. Что связывает эти два?';

  @override
  String get accessibilityAndLanguage => 'Доступность и Язык';

  @override
  String get language => 'Язык';

  @override
  String get textSize => 'Размер текста';

  @override
  String get themeMode => 'Режим темы';

  @override
  String get systemTheme => 'Система';

  @override
  String get lightThemeOption => 'Светлая';

  @override
  String get darkThemeOption => 'Тёмная';

  @override
  String get dynamicColors => 'Динамические цвета';

  @override
  String get dynamicColorsSubtitle =>
      'Смешайте интерфейс с адаптивными градиентами и подсветкой.';

  @override
  String get motionEffects => 'Движение и Анимации';

  @override
  String get motionEffectsSubtitle =>
      'Отключите анимации, если предпочитаете более спокойный интерфейс.';

  @override
  String get liveTournamentFeed => 'Лента Турнира в Прямом Эфире';

  @override
  String get liveTournamentFeedEmpty =>
      'Живые сетки и искры матчей появятся здесь, как только начнутся турниры.';

  @override
  String get futurePlaybook => 'Плейбук Будущего';

  @override
  String get futurePlaybookSubtitle =>
      'Предстоящие тренды, подготовленные на следующее десятилетие';

  @override
  String get levelsChallenges => 'Уровни и Вызовы';

  @override
  String get levelsChallengesSubtitle =>
      'Просмотрите структурированные уровни и их вызовы';

  @override
  String get close => 'Закрыть';

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
