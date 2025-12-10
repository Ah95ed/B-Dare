import 'package:flutter/material.dart';
import '../../domain/entities/tournament_stage.dart';
import '../../../../core/theme/colors.dart';
import '../../../../l10n/app_localizations.dart';

/// مؤشر المرحلة
class StageIndicator extends StatelessWidget {
  final TournamentStage stage;

  const StageIndicator({
    super.key,
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 1,
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
                    stage.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                _buildStatusChip(context),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Progress
            Row(
              children: [
                Text(
                  l10n.stageRoundProgress(
                    stage.roundNumber,
                    stage.totalRounds,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                Text(
                  '${stage.completedMatches.length}/${stage.matches.length}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                      ),
                ),
                const SizedBox(width: 4),
                Text(
                  l10n.matchesLabel,
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Progress Bar
            LinearProgressIndicator(
              value: stage.matches.isEmpty
                  ? 0
                  : stage.completedMatches.length / stage.matches.length,
              backgroundColor: AppColors.accent.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                _getStatusColor(stage.status),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Format & Dates
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                 Text(
                   '${stage.format.name} • ${_formatDate(context, stage.startDate)}',
                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
                         color: Colors.grey[600],
                       ),
                 ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Color color;
    String label;
    IconData icon;

    switch (stage.status) {
      case StageStatus.notStarted:
        color = Colors.grey;
        label = l10n.stageStatusNotStarted;
        icon = Icons.schedule;
        break;
      case StageStatus.inProgress:
        color = Colors.orange;
        label = l10n.stageStatusInProgress;
        icon = Icons.play_circle;
        break;
      case StageStatus.completed:
        color = Colors.green;
        label = l10n.stageStatusCompleted;
        icon = Icons.check_circle;
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

  Color _getStatusColor(StageStatus status) {
    switch (status) {
      case StageStatus.notStarted:
        return Colors.grey;
      case StageStatus.inProgress:
        return Colors.orange;
      case StageStatus.completed:
        return Colors.green;
    }
  }

  String _formatDate(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays > 0) {
      return l10n.relativeInDays(difference.inDays);
    } else if (difference.inHours > 0) {
      return l10n.relativeInHours(difference.inHours);
    } else if (difference.inMinutes > 0) {
      return l10n.relativeInMinutes(difference.inMinutes);
    } else if (difference.inDays < 0) {
      return l10n.relativeStarted;
    } else {
      return l10n.relativeNow;
    }
  }
}

