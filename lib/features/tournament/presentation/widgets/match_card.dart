import 'package:flutter/material.dart';
import '../../domain/entities/match.dart';
import '../../../../core/theme/colors.dart';
import 'team_card.dart';

/// بطاقة المباراة
class MatchCard extends StatelessWidget {
  final Match match;
  final bool showDetails;

  const MatchCard({
    super.key,
    required this.match,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${match.team1.name} vs ${match.team2.name}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                _buildStatusChip(context),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Teams
            Row(
              children: [
                Expanded(
                  child: TeamCard(team: match.team1),
                ),
                const SizedBox(width: 16),
                Text(
                  'VS',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                      ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TeamCard(team: match.team2),
                ),
              ],
            ),
            
            // Score
            if (match.gameResults.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      match.currentScore,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                    ),
                  ],
                ),
              ),
            ],
            
            // Details
            if (showDetails) ...[
              const SizedBox(height: 16),
              Divider(color: Colors.grey[300]),
              const SizedBox(height: 8),
              _buildDetailRow(
                context,
                Icons.schedule,
                'الوقت المحدد',
                _formatDateTime(match.scheduledTime),
              ),
              if (match.startTime != null)
                _buildDetailRow(
                  context,
                  Icons.play_circle,
                  'وقت البدء',
                  _formatDateTime(match.startTime!),
                ),
              if (match.endTime != null)
                _buildDetailRow(
                  context,
                  Icons.check_circle,
                  'وقت الانتهاء',
                  _formatDateTime(match.endTime!),
                ),
              _buildDetailRow(
                context,
                Icons.format_list_numbered,
                'النظام',
                match.format.name,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (match.status) {
      case MatchStatus.scheduled:
        color = Colors.blue;
        label = 'مجدولة';
        icon = Icons.schedule;
        break;
      case MatchStatus.inProgress:
        color = Colors.orange;
        label = 'جارية';
        icon = Icons.play_circle;
        break;
      case MatchStatus.completed:
        color = AppColors.success;
        label = 'مكتملة';
        icon = Icons.check_circle;
        break;
      case MatchStatus.forfeited:
        color = Colors.red;
        label = 'انسحاب';
        icon = Icons.cancel;
        break;
      case MatchStatus.cancelled:
        color = Colors.grey;
        label = 'ملغاة';
        icon = Icons.block;
        break;
    }

    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.1),
      labelStyle: TextStyle(color: color, fontSize: 12),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

