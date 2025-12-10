import '../../domain/entities/leaderboard_entry.dart';

class LeaderboardService {
  // In real implementation, this would fetch from a backend API
  // For now, we'll use mock data

  Future<List<LeaderboardEntry>> getGlobalPlayerRankings({int limit = 100}) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock data - in real implementation, fetch from server
    return List.generate(limit, (index) {
      return LeaderboardEntry(
        id: 'player_$index',
        name: 'Player ${index + 1}',
        rank: index + 1,
        score: 10000 - (index * 50),
        metadata: {
          'level': (index ~/ 10) + 1,
          'gamesPlayed': (index + 1) * 5,
          'winRate': 0.7 + (index % 3) * 0.1,
        },
      );
    });
  }

  Future<List<GroupLeaderboardEntry>> getGlobalGroupRankings({int limit = 50}) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock data - in real implementation, fetch from server
    return List.generate(limit, (index) {
      return GroupLeaderboardEntry(
        id: 'group_$index',
        name: 'Group ${index + 1}',
        rank: index + 1,
        totalScore: 50000 - (index * 200),
        memberCount: 3 + (index % 4),
        metadata: {
          'gamesPlayed': (index + 1) * 10,
          'averageScore': 8000 - (index * 30),
        },
      );
    });
  }

  Future<LeaderboardEntry?> getTopPlayer() async {
    final rankings = await getGlobalPlayerRankings(limit: 1);
    return rankings.isNotEmpty ? rankings.first : null;
  }

  Future<GroupLeaderboardEntry?> getTopGroup() async {
    final rankings = await getGlobalGroupRankings(limit: 1);
    return rankings.isNotEmpty ? rankings.first : null;
  }

  Future<int?> getUserRank(String userId) async {
    final rankings = await getGlobalPlayerRankings();
    final userIndex = rankings.indexWhere((entry) => entry.id == userId);
    return userIndex >= 0 ? rankings[userIndex].rank : null;
  }
}

