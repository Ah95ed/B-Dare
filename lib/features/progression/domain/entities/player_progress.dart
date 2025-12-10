class PlayerProgress {
  final int level;
  final int xpInLevel;
  final int totalXp;
  final int gamesPlayed;
  final int perfectGames;
  final int dailyStreak;
  final DateTime? lastDailyCompletion;
  final int unlockedPhaseIndex;
  final Map<String, int> phaseWins;
  final Map<String, int> phasePerfectWins;
  final Map<String, int> phaseStreaks;

  const PlayerProgress({
    required this.level,
    required this.xpInLevel,
    required this.totalXp,
    required this.gamesPlayed,
    required this.perfectGames,
    required this.dailyStreak,
    required this.lastDailyCompletion,
    required this.unlockedPhaseIndex,
    required this.phaseWins,
    required this.phasePerfectWins,
    required this.phaseStreaks,
  });

  factory PlayerProgress.initial() => const PlayerProgress(
        level: 1,
        xpInLevel: 0,
        totalXp: 0,
        gamesPlayed: 0,
        perfectGames: 0,
        dailyStreak: 0,
        lastDailyCompletion: null,
        unlockedPhaseIndex: 0,
        phaseWins: {},
        phasePerfectWins: {},
        phaseStreaks: {},
      );

  PlayerProgress copyWith({
    int? level,
    int? xpInLevel,
    int? totalXp,
    int? gamesPlayed,
    int? perfectGames,
    int? dailyStreak,
    DateTime? lastDailyCompletion,
    int? unlockedPhaseIndex,
    Map<String, int>? phaseWins,
    Map<String, int>? phasePerfectWins,
    Map<String, int>? phaseStreaks,
  }) {
    return PlayerProgress(
      level: level ?? this.level,
      xpInLevel: xpInLevel ?? this.xpInLevel,
      totalXp: totalXp ?? this.totalXp,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      perfectGames: perfectGames ?? this.perfectGames,
      dailyStreak: dailyStreak ?? this.dailyStreak,
      lastDailyCompletion: lastDailyCompletion ?? this.lastDailyCompletion,
      unlockedPhaseIndex: unlockedPhaseIndex ?? this.unlockedPhaseIndex,
      phaseWins: phaseWins ?? this.phaseWins,
      phasePerfectWins: phasePerfectWins ?? this.phasePerfectWins,
      phaseStreaks: phaseStreaks ?? this.phaseStreaks,
    );
  }

  Map<String, dynamic> toJson() => {
        'level': level,
        'xpInLevel': xpInLevel,
        'totalXp': totalXp,
        'gamesPlayed': gamesPlayed,
        'perfectGames': perfectGames,
        'dailyStreak': dailyStreak,
        'lastDailyCompletion': lastDailyCompletion?.toIso8601String(),
        'unlockedPhaseIndex': unlockedPhaseIndex,
        'phaseWins': phaseWins,
        'phasePerfectWins': phasePerfectWins,
        'phaseStreaks': phaseStreaks,
      };

  factory PlayerProgress.fromJson(Map<String, dynamic> json) {
    return PlayerProgress(
      level: json['level'] as int? ?? 1,
      xpInLevel: json['xpInLevel'] as int? ?? 0,
      totalXp: json['totalXp'] as int? ?? 0,
      gamesPlayed: json['gamesPlayed'] as int? ?? 0,
      perfectGames: json['perfectGames'] as int? ?? 0,
      dailyStreak: json['dailyStreak'] as int? ?? 0,
      lastDailyCompletion: json['lastDailyCompletion'] != null
          ? DateTime.tryParse(json['lastDailyCompletion'] as String)
          : null,
      unlockedPhaseIndex: json['unlockedPhaseIndex'] as int? ?? 0,
      phaseWins: Map<String, int>.from(
        (json['phaseWins'] as Map?) ?? const {},
      ),
      phasePerfectWins: Map<String, int>.from(
        (json['phasePerfectWins'] as Map?) ?? const {},
      ),
      phaseStreaks: Map<String, int>.from(
        (json['phaseStreaks'] as Map?) ?? const {},
      ),
    );
  }
}
