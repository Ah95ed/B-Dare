import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class GroupPlayerRoster extends StatelessWidget {
  final List<PlayerDisplayInfo> players;

  const GroupPlayerRoster({
    super.key,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'Add players to personalize the group experience.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Players (${players.length})',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: players
                .map(
                  (player) => Chip(
                    avatar: Icon(
                      player.isHost ? Icons.star : Icons.person,
                      size: 18,
                      color: player.isHost
                          ? AppColors.accent
                          : AppColors.primary,
                    ),
                    label: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          player.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontWeight: player.isCurrent
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                        ),
                        Text(
                          '${player.score} pts',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    backgroundColor: player.isCurrent
                        ? AppColors.accent.withValues(alpha: 0.2)
                        : player.isHost
                            ? AppColors.accent.withValues(alpha: 0.12)
                            : AppColors.primary.withValues(alpha: 0.08),
                    side: player.isCurrent
                        ? const BorderSide(color: AppColors.accent, width: 1.5)
                        : BorderSide.none,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class PlayerDisplayInfo {
  final String name;
  final bool isHost;
  final bool isCurrent;
  final int score;

  const PlayerDisplayInfo({
    required this.name,
    this.isHost = false,
    this.isCurrent = false,
    this.score = 0,
  });
}
