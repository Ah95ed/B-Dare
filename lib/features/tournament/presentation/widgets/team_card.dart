import 'package:flutter/material.dart';
import '../../domain/entities/team.dart';
import '../../../../core/theme/colors.dart';

/// بطاقة الفريق
class TeamCard extends StatelessWidget {
  final Team team;
  final VoidCallback? onTap;

  const TeamCard({
    super.key,
    required this.team,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary,
              child: team.avatarUrl != null
                  ? ClipOval(
                      child: Image.network(
                        team.avatarUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Text(
                      team.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),

            const SizedBox(height: 8),

            // Team Name
            Text(
              team.name,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${team.memberCount}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                if (team.stats.matchesPlayed > 0) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.emoji_events, size: 12, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${team.stats.matchesWon}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ],
            ),

            // Seed
            if (team.seed != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Chip(
                  label: Text('#${team.seed}'),
                  backgroundColor: AppColors.accent.withValues(alpha: 0.2),
                  labelStyle: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
