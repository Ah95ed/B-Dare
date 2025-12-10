enum AchievementType {
  firstWin,
  perfectChain,
  speedRunner,
  dailyHero,
}

class Achievement {
  final AchievementType type;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.type,
    required this.isUnlocked,
    required this.unlockedAt,
  });

  factory Achievement.locked(AchievementType type) =>
      Achievement(type: type, isUnlocked: false, unlockedAt: null);

  Achievement copyWith({
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      type: type,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'isUnlocked': isUnlocked,
        'unlockedAt': unlockedAt?.toIso8601String(),
      };

  factory Achievement.fromJson(Map<String, dynamic> json) {
    final typeName = json['type'] as String;
    final match = AchievementType.values
        .firstWhere((element) => element.name == typeName,
            orElse: () => AchievementType.firstWin);

    return Achievement(
      type: match,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.tryParse(json['unlockedAt'] as String)
          : null,
    );
  }

  String get title {
    switch (type) {
      case AchievementType.firstWin:
        return 'First Link';
      case AchievementType.perfectChain:
        return 'Perfect Chain';
      case AchievementType.speedRunner:
        return 'Speed Runner';
      case AchievementType.dailyHero:
        return 'Daily Hero';
    }
  }

  String get description {
    switch (type) {
      case AchievementType.firstWin:
        return 'Complete your first puzzle.';
      case AchievementType.perfectChain:
        return 'Finish a puzzle without mistakes.';
      case AchievementType.speedRunner:
        return 'Finish a puzzle in under 60 seconds.';
      case AchievementType.dailyHero:
        return 'Beat the daily challenge.';
    }
  }
}
