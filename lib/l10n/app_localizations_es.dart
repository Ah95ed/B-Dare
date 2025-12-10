// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Misterio Enlazado';

  @override
  String get soloMode => 'Modo Individual';

  @override
  String get groupMode => 'Modo Grupal';

  @override
  String get practiceMode => 'Modo Práctica';

  @override
  String get startGame => 'Iniciar Juego';

  @override
  String get selectDifficulty => 'Seleccionar Dificultad';

  @override
  String get selectRepresentation => 'Seleccionar Tipo de Representación';

  @override
  String get text => 'Texto';

  @override
  String get icon => 'Icono';

  @override
  String get image => 'Imagen';

  @override
  String get event => 'Evento';

  @override
  String get links => 'Enlaces';

  @override
  String get timeRemaining => 'Tiempo Restante';

  @override
  String get step => 'Paso';

  @override
  String get ofLabel => 'de';

  @override
  String get correct => '¡Correcto!';

  @override
  String get wrong => '¡Incorrecto!';

  @override
  String get timeOut => '¡Se Acabó el Tiempo!';

  @override
  String get score => 'Puntuación';

  @override
  String get timeSpent => 'Tiempo Empleado';

  @override
  String get correctChain => 'Cadena Correcta';

  @override
  String get yourChoices => 'Tus Elecciones';

  @override
  String get playAgain => 'Jugar de Nuevo';

  @override
  String get share => 'Compartir';

  @override
  String get backToHome => 'Volver al Inicio';

  @override
  String get selectPlayers => 'Seleccionar Número de Jugadores';

  @override
  String get player => 'Jugador';

  @override
  String get points => 'Puntos';

  @override
  String get nextPlayer => 'Siguiente Jugador';

  @override
  String get gameOver => 'Juego Terminado';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Reintentar';

  @override
  String get perfectWin => '¡Perfecto! ¡Completaste la cadena correctamente!';

  @override
  String get timeUpMessage =>
      '¡Se acabó el tiempo! No te preocupes, puedes intentarlo de nuevo.';

  @override
  String get tieMessage => '¡Es un empate! ¡Gran juego todos!';

  @override
  String get helpText =>
      'Encuentra el enlace que conecta la tarjeta actual con el objetivo. Piensa en la relación entre ellos.';

  @override
  String get guidedModeHint =>
      'Lee la pista antes de elegir: Busca el enlace que conecta la tarjeta actual con el objetivo.';

  @override
  String get wellDone => '¡Bien hecho!';

  @override
  String get keepTrying => '¡Sigue intentando! ¡Estás mejorando!';

  @override
  String get excellent => '¡Excelente!';

  @override
  String get goodJob => '¡Buen trabajo!';

  @override
  String get almostThere => '¡Casi lo tienes!';

  @override
  String get thinkAgain => 'Piensa de nuevo. ¿Qué conecta estos dos?';

  @override
  String get accessibilityAndLanguage => 'Accesibilidad e Idioma';

  @override
  String get language => 'Idioma';

  @override
  String get textSize => 'Tamaño del Texto';

  @override
  String get themeMode => 'Modo de tema';

  @override
  String get systemTheme => 'Sistema';

  @override
  String get lightThemeOption => 'Claro';

  @override
  String get darkThemeOption => 'Oscuro';

  @override
  String get dynamicColors => 'Colores dinámicos';

  @override
  String get dynamicColorsSubtitle =>
      'Mezcla la interfaz con degradados y acentos adaptables.';

  @override
  String get motionEffects => 'Movimiento y animaciones';

  @override
  String get motionEffectsSubtitle =>
      'Desactiva las animaciones si prefieres una interfaz tranquila.';

  @override
  String get liveTournamentFeed => 'Transmisión de torneos en vivo';

  @override
  String get liveTournamentFeedEmpty =>
      'Los cuadros y partidas aparecerán aquí cuando empiecen los torneos.';

  @override
  String get futurePlaybook => 'Playbook del futuro';

  @override
  String get futurePlaybookSubtitle =>
      'Tendencias preparadas para la próxima década';

  @override
  String get levelsChallenges => 'Niveles y desafíos';

  @override
  String get levelsChallengesSubtitle =>
      'Explora los niveles estructurados antes de jugar';

  @override
  String get close => 'Cerrar';

  @override
  String dailySessionStatusCompleted(int streak) {
    return '¡Terminaste la sesión de hoy! Racha de $streak días';
  }

  @override
  String dailySessionStatusNotStarted(int streak) {
    return 'Aún no has comenzado la sesión de hoy · Racha actual: $streak días';
  }

  @override
  String dailySessionTotalSessions(int count) {
    return 'Total de sesiones: $count';
  }

  @override
  String get brainGymStartNow => 'Iniciar Brain Gym ahora';

  @override
  String familySessionsTitleWithProfile(String profile) {
    return 'Sesiones de $profile';
  }

  @override
  String get familySessionsTitleDefault => 'Sesiones familiares';

  @override
  String get sessionsLabel => 'Sesiones';

  @override
  String get winsLabel => 'Victorias';

  @override
  String get lastSessionLabel => 'Última sesión';

  @override
  String familyWeeklyGoal(int wins) {
    return 'Objetivo de esta semana: ganar 3 sesiones familiares. Progreso actual $wins/3.';
  }

  @override
  String familyWinsSessionsSummary(int wins, int sessions) {
    return 'Victorias: $wins / Sesiones: $sessions';
  }

  @override
  String get familyNoSessionYet => '¡Comienza tu primera sesión familiar hoy!';

  @override
  String get familyStartNewSession => 'Iniciar nueva sesión';

  @override
  String get keepPlayingToMaintainProgress =>
      '¡Sigue jugando para mantener tu progreso!';

  @override
  String get guidedModeTitle => 'Modo Guiado';

  @override
  String get guidedModeDescription =>
      'Pasos simplificados y pistas para jugadores más jóvenes y principiantes.';

  @override
  String get soloModeDescription => 'Juega solo y desafíate a ti mismo';

  @override
  String get createGroupTitle => 'Crear Grupo';

  @override
  String get createGroupDescription => 'Crea un juego grupal con amigos';

  @override
  String get globalTournamentsTitle => 'Torneos Globales';

  @override
  String get globalTournamentsDescription =>
      'Únete a torneos globales y conviértete en campeón mundial';

  @override
  String get progressKeepPlayingHint =>
      '¡Sigue jugando para mantener tu impulso!';

  @override
  String get brainGymSessionCompletedFinal =>
      '🎯 ¡Terminaste tu sesión de Brain Gym!';

  @override
  String get brainGymPerfectRoundHeadline => '💪 ¡Ronda perfecta!';

  @override
  String get brainGymNewRoundHeadline => '¡Genial! Nueva ronda de Brain Gym';

  @override
  String brainGymCurrentStreak(int streak) {
    return 'Tu racha actual: $streak días';
  }

  @override
  String get brainGymStartNewStreak => 'Comienza una nueva racha hoy';

  @override
  String brainGymRoundProgress(int current, int total, int score) {
    return 'Ronda $current de $total · Puntuación de sesión: $score';
  }

  @override
  String brainGymTotalSessions(int total) {
    return 'Total de sesiones de entrenamiento: $total';
  }

  @override
  String get guidedModeIntroStep1 =>
      'Escucha las instrucciones breves, luego lee los puntos de inicio y fin.';

  @override
  String get guidedModeIntroStep2 =>
      'Elige el enlace correcto de entre tres opciones simplificadas.';

  @override
  String get guidedModeIntroStep3 =>
      'Si cometes un error, obtendrás una pista instantánea para ayudarte la próxima vez.';

  @override
  String get guidedModeLongDescription =>
      'Una experiencia adecuada para jugadores más jóvenes y usuarios nuevos. Este modo se enfoca en cadenas cortas con pistas visuales y de audio.';

  @override
  String get guidedModeStartSession => 'Iniciar sesión guiada';

  @override
  String get selectGameTypeTitle => 'Elegir tipo de juego';

  @override
  String familySessionTitleWithProfileInGame(String profile) {
    return 'Equipo $profile';
  }

  @override
  String get familySessionTitleInGame => 'Sesión familiar';

  @override
  String get sessionsShortLabel => 'Sesiones';

  @override
  String get winsShortLabel => 'Victorias';

  @override
  String get lossesShortLabel => 'Derrotas';

  @override
  String get lastSessionShort => 'Última sesión';

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
  String get matchNotReady => 'El partido aún no está listo';

  @override
  String matchStartFailed(String error) {
    return 'Error al iniciar el partido: $error';
  }

  @override
  String matchJoinFailed(String error) {
    return 'Error al unirse al partido: $error';
  }

  @override
  String get tournamentGlobalTitle => 'Torneos Globales';

  @override
  String get tournamentNoTournaments => 'No hay torneos';

  @override
  String get tournamentFilterLabel => 'Filtro:';

  @override
  String get tournamentFilterAll => 'Todos';

  @override
  String get tournamentFilterRegistration => 'Registro';

  @override
  String get tournamentFilterQualifiers => 'Clasificatorias';

  @override
  String get tournamentFilterFinal => 'Final';

  @override
  String get tournamentFilterCompleted => 'Completados';

  @override
  String get tournamentEmptyTitle => 'No hay torneos en este momento';

  @override
  String get tournamentCreateNew => 'Crear nuevo torneo';

  @override
  String get tournamentStagesSectionTitle => 'Etapas';

  @override
  String tournamentTeamsSectionTitle(int count, int max) {
    return 'Equipos ($count/$max)';
  }

  @override
  String tournamentViewAllTeams(int count) {
    return 'Ver todos los equipos ($count)';
  }

  @override
  String get tournamentBracketTitle => 'Cuadro';

  @override
  String get tournamentBracketUnavailable => 'El cuadro aún no está disponible';

  @override
  String get tournamentViewBracket => 'Ver cuadro';

  @override
  String get tournamentStart => 'Iniciar torneo';

  @override
  String get back => 'Atrás';

  @override
  String get tournamentStatusRegistration => 'Registro';

  @override
  String get tournamentStatusQualifiers => 'Clasificatorias';

  @override
  String get tournamentStatusPlayoffs => 'Playoffs';

  @override
  String get tournamentStatusFinal => 'Final';

  @override
  String get tournamentStatusCompleted => 'Completados';

  @override
  String get tournamentStatusCancelled => 'Cancelados';

  @override
  String get tournamentMatchStatusScheduled => 'Programado';

  @override
  String get tournamentMatchStatusInProgress => 'En progreso';

  @override
  String get tournamentMatchStatusCompleted => 'Completado';

  @override
  String get tournamentMatchStatusForfeit => 'Abandono';

  @override
  String get tournamentMatchStatusCancelled => 'Cancelado';

  @override
  String get tournamentStatsTeams => 'Equipos';

  @override
  String get tournamentStatsStages => 'Etapas';

  @override
  String get tournamentStatsType => 'Tipo';

  @override
  String get tournamentTypeSingleElimination => 'Eliminación Simple';

  @override
  String get tournamentTypeDoubleElimination => 'Eliminación Doble';

  @override
  String get tournamentTypeSwiss => 'Suizo';

  @override
  String get tournamentTypeRoundRobin => 'Round Robin';

  @override
  String stageRoundProgress(int current, int total) {
    return 'Ronda $current/$total';
  }

  @override
  String get matchesLabel => 'Partidos';

  @override
  String get stageStatusNotStarted => 'No iniciado';

  @override
  String get stageStatusInProgress => 'En progreso';

  @override
  String get stageStatusCompleted => 'Completado';

  @override
  String relativeInDays(int days) {
    return 'En $days días';
  }

  @override
  String relativeInHours(int hours) {
    return 'En $hours horas';
  }

  @override
  String relativeInMinutes(int minutes) {
    return 'En $minutes minutos';
  }

  @override
  String get relativeStarted => 'Iniciado';

  @override
  String get relativeNow => 'Ahora';

  @override
  String get matchTitle => 'Partido';

  @override
  String get matchStart => 'Iniciar partido';

  @override
  String get matchJoin => 'Unirse al partido';

  @override
  String get samplePuzzleLoaded => 'Se cargó un rompecabezas de práctica';
}
