class AppConstants {
  static const String appName = 'Mystery Link';
  static const String appVersion = '1.0.0';
  
  // Routes
  static const String routeHome = '/';
  static const String routeModeSelection = '/mode-selection';
  static const String routeGuided = '/guided';
  static const String routeGame = '/game';
  static const String routeResult = '/result';
  static const String routePlayerManagement = '/player-management';
  static const String routeJoinGame = '/join-game';
  static const String routeCreateGroup = '/create-group';
  static const String routeLeaderboard = '/leaderboard';
  static const String routeMinigames = '/minigames';
  static const String routeTournaments = '/tournaments';
  static const String routeTournamentRegistration = '/tournament-registration';
  static const String routeMatch = '/match';
  static const String routeLevelSelection = '/levels';
  
  // Storage Keys
  static const String keyHighScores = 'high_scores';
  static const String keyPlayerName = 'player_name';
  static const String keySettings = 'settings';
  
  // Cloudflare Multiplayer
  static const String cloudflareWorkerUrl = 'wss://mystery-link-backend.dent19900.workers.dev';
  static const String cloudflareWorkerHttpUrl = 'https://mystery-link-backend.dent19900.workers.dev';
  
  // Tournament API
  static String get tournamentApiUrl => cloudflareWorkerHttpUrl;
}

