class LeaderboardEntry {
  final String id;
  final String name;
  final int rank;
  final int score;
  final String? avatarUrl;
  final Map<String, dynamic>? metadata;

  LeaderboardEntry({
    required this.id,
    required this.name,
    required this.rank,
    required this.score,
    this.avatarUrl,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rank': rank,
      'score': score,
      'avatarUrl': avatarUrl,
      'metadata': metadata,
    };
  }

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      id: json['id'],
      name: json['name'],
      rank: json['rank'],
      score: json['score'],
      avatarUrl: json['avatarUrl'],
      metadata: json['metadata'],
    );
  }
}

class GroupLeaderboardEntry {
  final String id;
  final String name;
  final int rank;
  final int totalScore;
  final int memberCount;
  final String? avatarUrl;
  final Map<String, dynamic>? metadata;

  GroupLeaderboardEntry({
    required this.id,
    required this.name,
    required this.rank,
    required this.totalScore,
    required this.memberCount,
    this.avatarUrl,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rank': rank,
      'totalScore': totalScore,
      'memberCount': memberCount,
      'avatarUrl': avatarUrl,
      'metadata': metadata,
    };
  }

  factory GroupLeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return GroupLeaderboardEntry(
      id: json['id'],
      name: json['name'],
      rank: json['rank'],
      totalScore: json['totalScore'],
      memberCount: json['memberCount'],
      avatarUrl: json['avatarUrl'],
      metadata: json['metadata'],
    );
  }
}

