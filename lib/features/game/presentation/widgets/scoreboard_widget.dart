import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class PlayerScore {
  final int id;
  final String name;
  final int score;

  PlayerScore({
    required this.id,
    required this.name,
    required this.score,
  });
}

class ScoreboardWidget extends StatelessWidget {
  final List<PlayerScore> players;
  final int? currentPlayerId;

  const ScoreboardWidget({
    super.key,
    required this.players,
    this.currentPlayerId,
  });

  @override
  Widget build(BuildContext context) {
    final sortedPlayers = List<PlayerScore>.from(players)
      ..sort((a, b) => b.score.compareTo(a.score));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scoreboard',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...sortedPlayers.asMap().entries.map((entry) {
              final index = entry.key;
              final player = entry.value;
              final isCurrent = player.id == currentPlayerId;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isCurrent
                      ? Border.all(color: AppColors.primary, width: 2)
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _getRankColor(index),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          player.name,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                              ),
                        ),
                        if (isCurrent) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.person,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${player.score}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 0:
        return AppColors.accent; // Gold
      case 1:
        return AppColors.textSecondary; // Silver
      case 2:
        return AppColors.warning; // Bronze
      default:
        return AppColors.textSecondary.withValues(alpha: 0.5);
    }
  }
}

