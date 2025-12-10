import 'package:equatable/equatable.dart';

class FamilySessionStats extends Equatable {
  final String? groupProfile;
  final int sessionsPlayed;
  final int wins;
  final int losses;
  final int totalTurns;
  final Duration totalPlayTime;
  final DateTime? lastSessionAt;

  const FamilySessionStats({
    this.groupProfile,
    this.sessionsPlayed = 0,
    this.wins = 0,
    this.losses = 0,
    this.totalTurns = 0,
    this.totalPlayTime = Duration.zero,
    this.lastSessionAt,
  });

  factory FamilySessionStats.initial() => const FamilySessionStats();

  FamilySessionStats copyWith({
    String? groupProfile,
    int? sessionsPlayed,
    int? wins,
    int? losses,
    int? totalTurns,
    Duration? totalPlayTime,
    DateTime? lastSessionAt,
  }) {
    return FamilySessionStats(
      groupProfile: groupProfile ?? this.groupProfile,
      sessionsPlayed: sessionsPlayed ?? this.sessionsPlayed,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      totalTurns: totalTurns ?? this.totalTurns,
      totalPlayTime: totalPlayTime ?? this.totalPlayTime,
      lastSessionAt: lastSessionAt ?? this.lastSessionAt,
    );
  }

  FamilySessionStats recordSession({
    required bool isWin,
    required int turnsInSession,
    required Duration duration,
    String? profile,
  }) {
    return FamilySessionStats(
      groupProfile: profile ?? groupProfile,
      sessionsPlayed: sessionsPlayed + 1,
      wins: isWin ? wins + 1 : wins,
      losses: isWin ? losses : losses + 1,
      totalTurns: totalTurns + turnsInSession,
      totalPlayTime: totalPlayTime + duration,
      lastSessionAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupProfile': groupProfile,
      'sessionsPlayed': sessionsPlayed,
      'wins': wins,
      'losses': losses,
      'totalTurns': totalTurns,
      'totalPlayTimeMs': totalPlayTime.inMilliseconds,
      'lastSessionAt': lastSessionAt?.millisecondsSinceEpoch,
    };
  }

  factory FamilySessionStats.fromJson(Map<String, dynamic> json) {
    return FamilySessionStats(
      groupProfile: json['groupProfile'] as String?,
      sessionsPlayed: json['sessionsPlayed'] as int? ?? 0,
      wins: json['wins'] as int? ?? 0,
      losses: json['losses'] as int? ?? 0,
      totalTurns: json['totalTurns'] as int? ?? 0,
      totalPlayTime: Duration(
        milliseconds: json['totalPlayTimeMs'] as int? ?? 0,
      ),
      lastSessionAt: json['lastSessionAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              json['lastSessionAt'] as int,
            )
          : null,
    );
  }

  @override
  List<Object?> get props => [
        groupProfile,
        sessionsPlayed,
        wins,
        losses,
        totalTurns,
        totalPlayTime,
        lastSessionAt,
      ];
}
