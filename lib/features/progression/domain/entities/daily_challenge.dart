import '../../../game/domain/entities/link_node.dart';

class DailyChallengeConfig {
  final RepresentationType representationType;
  final int linksCount;

  const DailyChallengeConfig({
    required this.representationType,
    required this.linksCount,
  });
}

class DailyChallengeStatus {
  final DateTime today;
  final DateTime? lastCompletionDate;
  final int streakCount;
  final bool completedToday;
  final int bestScore;

  const DailyChallengeStatus({
    required this.today,
    required this.lastCompletionDate,
    required this.streakCount,
    required this.completedToday,
    required this.bestScore,
  });

  factory DailyChallengeStatus.initial() => DailyChallengeStatus(
        today: DateTime.now(),
        lastCompletionDate: null,
        streakCount: 0,
        completedToday: false,
        bestScore: 0,
      );

  DailyChallengeStatus copyWith({
    DateTime? today,
    DateTime? lastCompletionDate,
    int? streakCount,
    bool? completedToday,
    int? bestScore,
  }) {
    return DailyChallengeStatus(
      today: today ?? this.today,
      lastCompletionDate: lastCompletionDate ?? this.lastCompletionDate,
      streakCount: streakCount ?? this.streakCount,
      completedToday: completedToday ?? this.completedToday,
      bestScore: bestScore ?? this.bestScore,
    );
  }

  Map<String, dynamic> toJson() => {
        'lastCompletionDate': lastCompletionDate?.toIso8601String(),
        'streakCount': streakCount,
        'bestScore': bestScore,
      };

  factory DailyChallengeStatus.fromJson(Map<String, dynamic> json) {
    return DailyChallengeStatus(
      today: DateTime.now(),
      lastCompletionDate: json['lastCompletionDate'] != null
          ? DateTime.tryParse(json['lastCompletionDate'] as String)
          : null,
      streakCount: json['streakCount'] as int? ?? 0,
      completedToday: false,
      bestScore: json['bestScore'] as int? ?? 0,
    );
  }
}
