import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/entities/leaderboard_entry.dart';
import '../../data/services/leaderboard_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final LeaderboardService _leaderboardService = LeaderboardService();

  List<LeaderboardEntry> _playerRankings = [];
  List<GroupLeaderboardEntry> _groupRankings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRankings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadRankings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final players = await _leaderboardService.getGlobalPlayerRankings();
      final groups = await _leaderboardService.getGlobalGroupRankings();

      setState(() {
        _playerRankings = players;
        _groupRankings = groups;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load rankings: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Leaderboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'Players'),
            Tab(icon: Icon(Icons.people), text: 'Groups'),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              _loadRankings();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'daily', child: Text('Daily')),
              const PopupMenuItem(value: 'weekly', child: Text('Weekly')),
              const PopupMenuItem(value: 'monthly', child: Text('Monthly')),
              const PopupMenuItem(value: 'all', child: Text('All Time')),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPlayerLeaderboard(),
                _buildGroupLeaderboard(),
              ],
            ),
    );
  }

  Widget _buildPlayerLeaderboard() {
    if (_playerRankings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events_outlined,
                size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'No rankings available',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRankings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _playerRankings.length,
        itemBuilder: (context, index) {
          final entry = _playerRankings[index];
          final isTopThree = entry.rank <= 3;

          return _buildPlayerCard(entry, isTopThree);
        },
      ),
    );
  }

  Widget _buildPlayerCard(LeaderboardEntry entry, bool isTopThree) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isTopThree ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isTopThree
            ? BorderSide(color: _getRankColor(entry.rank), width: 2)
            : BorderSide.none,
      ),
      child: Container(
        decoration: isTopThree
            ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getRankColor(entry.rank).withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: _buildRankBadge(entry.rank),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  entry.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isTopThree ? FontWeight.bold : FontWeight.normal,
                      ),
                ),
              ),
              if (entry.metadata != null && entry.metadata!['level'] != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Lv. ${entry.metadata!['level']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
            ],
          ),
          subtitle: entry.metadata != null
              ? Text(
                  '${entry.metadata!['gamesPlayed']} games • ${(entry.metadata!['winRate']! * 100).toStringAsFixed(0)}% win rate',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              : null,
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.score}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              Text(
                'points',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    if (rank == 1) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accent,
              AppColors.accent.withValues(alpha: 0.7),
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, color: Colors.white, size: 24),
            Text(
              '$rank',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
    }

    if (rank == 2) {
      return Container(
        width: 45,
        height: 45,
        decoration: const BoxDecoration(
          color: AppColors.textSecondary,
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, color: Colors.white, size: 20),
            Text(
              '$rank',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
    }

    if (rank == 3) {
      return Container(
        width: 45,
        height: 45,
        decoration: const BoxDecoration(
          color: AppColors.warning,
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, color: Colors.white, size: 20),
            Text(
              '$rank',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$rank',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return AppColors.accent;
    if (rank == 2) return AppColors.textSecondary;
    if (rank == 3) return AppColors.warning;
    return AppColors.primary;
  }

  Widget _buildGroupLeaderboard() {
    if (_groupRankings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.groups_outlined,
                size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'No group rankings available',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRankings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _groupRankings.length,
        itemBuilder: (context, index) {
          final entry = _groupRankings[index];
          final isTopThree = entry.rank <= 3;

          return _buildGroupCard(entry, isTopThree);
        },
      ),
    );
  }

  Widget _buildGroupCard(GroupLeaderboardEntry entry, bool isTopThree) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isTopThree ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isTopThree
            ? BorderSide(color: _getRankColor(entry.rank), width: 2)
            : BorderSide.none,
      ),
      child: Container(
        decoration: isTopThree
            ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getRankColor(entry.rank).withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: _buildRankBadge(entry.rank),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  entry.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isTopThree ? FontWeight.bold : FontWeight.normal,
                      ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people,
                        size: 16, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Text(
                      '${entry.memberCount}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          subtitle: entry.metadata != null
              ? Text(
                  '${entry.metadata!['gamesPlayed']} games • Avg: ${entry.metadata!['averageScore']}',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              : null,
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.totalScore}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
              ),
              Text(
                'total',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
