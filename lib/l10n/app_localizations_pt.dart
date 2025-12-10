// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Mystery Link';

  @override
  String get soloMode => 'Modo Solo';

  @override
  String get groupMode => 'Modo em Grupo';

  @override
  String get practiceMode => 'Modo Prática';

  @override
  String get startGame => 'Iniciar Jogo';

  @override
  String get selectDifficulty => 'Selecionar Dificuldade';

  @override
  String get selectRepresentation => 'Selecionar Tipo de Representação';

  @override
  String get text => 'Texto';

  @override
  String get icon => 'Ícone';

  @override
  String get image => 'Imagem';

  @override
  String get event => 'Evento';

  @override
  String get links => 'Links';

  @override
  String get timeRemaining => 'Tempo Restante';

  @override
  String get step => 'Passo';

  @override
  String get ofLabel => 'de';

  @override
  String get correct => 'Correto!';

  @override
  String get wrong => 'Errado!';

  @override
  String get timeOut => 'Tempo Esgotado!';

  @override
  String get score => 'Pontuação';

  @override
  String get timeSpent => 'Tempo Gasto';

  @override
  String get correctChain => 'Cadeia Correta';

  @override
  String get yourChoices => 'Suas Escolhas';

  @override
  String get playAgain => 'Jogar Novamente';

  @override
  String get share => 'Compartilhar';

  @override
  String get backToHome => 'Voltar ao Início';

  @override
  String get selectPlayers => 'Selecionar Número de Jogadores';

  @override
  String get player => 'Jogador';

  @override
  String get points => 'Pontos';

  @override
  String get nextPlayer => 'Próximo Jogador';

  @override
  String get gameOver => 'Fim de Jogo';

  @override
  String get loading => 'Carregando...';

  @override
  String get error => 'Erro';

  @override
  String get retry => 'Tentar Novamente';

  @override
  String get perfectWin => 'Perfeito! Você completou a cadeia corretamente!';

  @override
  String get timeUpMessage =>
      'Tempo esgotado! Não se preocupe, você pode tentar novamente.';

  @override
  String get tieMessage => 'Empate! Ótimo jogo, pessoal!';

  @override
  String get helpText =>
      'Encontre o link que conecta o cartão atual ao objetivo. Pense sobre a relação entre eles.';

  @override
  String get guidedModeHint =>
      'Leia a dica antes de escolher: Procure o link que conecta o cartão atual ao alvo.';

  @override
  String get wellDone => 'Muito bem!';

  @override
  String get keepTrying => 'Continue tentando! Você está melhorando!';

  @override
  String get excellent => 'Excelente!';

  @override
  String get goodJob => 'Bom trabalho!';

  @override
  String get almostThere => 'Quase lá!';

  @override
  String get thinkAgain => 'Pense novamente. O que conecta esses dois?';

  @override
  String get accessibilityAndLanguage => 'Acessibilidade e Idioma';

  @override
  String get language => 'Idioma';

  @override
  String get textSize => 'Tamanho do Texto';

  @override
  String get themeMode => 'Modo de Tema';

  @override
  String get systemTheme => 'Sistema';

  @override
  String get lightThemeOption => 'Claro';

  @override
  String get darkThemeOption => 'Escuro';

  @override
  String get dynamicColors => 'Cores Dinâmicas';

  @override
  String get dynamicColorsSubtitle =>
      'Misture a interface com gradientes e destaques adaptativos.';

  @override
  String get motionEffects => 'Movimento e Animações';

  @override
  String get motionEffectsSubtitle =>
      'Desative animações se preferir uma interface mais calma.';

  @override
  String get liveTournamentFeed => 'Feed de Torneio ao Vivo';

  @override
  String get liveTournamentFeedEmpty =>
      'Chaves ao vivo e faíscas de partidas aparecerão aqui quando os torneios começarem.';

  @override
  String get futurePlaybook => 'Playbook do Futuro';

  @override
  String get futurePlaybookSubtitle =>
      'Tendências futuras preparadas para a próxima década';

  @override
  String get levelsChallenges => 'Níveis e Desafios';

  @override
  String get levelsChallengesSubtitle =>
      'Navegue por níveis estruturados e seus desafios';

  @override
  String get close => 'Fechar';

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
