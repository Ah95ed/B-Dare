import 'package:flutter/material.dart';
import '../../domain/entities/match.dart';
import '../../domain/entities/team.dart';
import '../../../../core/theme/colors.dart';

/// عقدة المباراة في شجرة التصفيات
class MatchNode extends StatelessWidget {
  final Match match;
  final VoidCallback? onTap;

  const MatchNode({
    super.key,
    required this.match,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: _getMatchColor().withValues(alpha: 0.1),
          border: Border.all(
            color: _getMatchColor(),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Team 1
            _buildTeamRow(match.team1, match.winner?.id == match.team1.id),

            // Divider
            Container(
              height: 1,
              color: _getMatchColor(),
            ),

            // Team 2
            _buildTeamRow(match.team2, match.winner?.id == match.team2.id),

            // Score
            if (match.gameResults.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getMatchColor().withValues(alpha: 0.2),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  match.currentScore,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getMatchColor(),
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamRow(Team team, bool isWinner) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // Team Avatar
          CircleAvatar(
            radius: 16,
            backgroundColor: isWinner
                ? AppColors.success.withValues(alpha: 0.2)
                : Colors.grey[300],
            child: Text(
              team.name[0].toUpperCase(),
              style: TextStyle(
                color: isWinner ? AppColors.success : Colors.grey[700],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Team Name
          Expanded(
            child: Text(
              team.name,
              style: TextStyle(
                fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
                color: isWinner ? AppColors.success : Colors.black87,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Winner Icon
          if (isWinner)
            const Icon(
              Icons.emoji_events,
              size: 16,
              color: AppColors.success,
            ),
        ],
      ),
    );
  }

  Color _getMatchColor() {
    switch (match.status) {
      case MatchStatus.scheduled:
        return Colors.grey;
      case MatchStatus.inProgress:
        return Colors.orange;
      case MatchStatus.completed:
        return AppColors.success;
      case MatchStatus.forfeited:
        return Colors.red;
      case MatchStatus.cancelled:
        return Colors.grey[400]!;
    }
  }
}
