import 'package:flutter/material.dart';
import '../../domain/entities/tournament.dart';
import '../../../../core/theme/colors.dart';

class TournamentCard extends StatelessWidget {
  final Tournament tournament;
  final VoidCallback? onTap;
  final bool enableMotion;
  final bool enableDynamicColors;

  const TournamentCard({
    super.key,
    required this.tournament,
    this.onTap,
    this.enableMotion = true,
    this.enableDynamicColors = false,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = enableDynamicColors
        ? LinearGradient(
            colors: [
              AppColors.cardStart.withValues(alpha: 0.12),
              AppColors.cardEnd.withValues(alpha: 0.12),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : null;
    final isActiveStage = tournament.status == TournamentStatus.qualifiers ||
        tournament.status == TournamentStatus.playoffs ||
        tournament.status == TournamentStatus.finalStage;
    final scale = isActiveStage ? 1.01 : 1.0;

    return AnimatedScale(
      duration: enableMotion ? const Duration(milliseconds: 260) : Duration.zero,
      scale: scale,
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          tournament.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent,
                              ),
                        ),
                      ),
                      _buildStatusChip(context),
                    ],
                  ),
                  if (tournament.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      tournament.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildStatItem(
                        context,
                        Icons.people,
                        '${tournament.currentTeams}/${tournament.maxTeams}',
                        'U?O�U,',
                      ),
                      const SizedBox(width: 16),
                      _buildStatItem(
                        context,
                        Icons.calendar_today,
                        _formatDate(tournament.startDate),
                        'O"O_O�USOc',
                      ),
                      const SizedBox(width: 16),
                      if (tournament.prizePool != null)
                        _buildStatItem(
                          context,
                          Icons.emoji_events,
                          tournament.prizePool!,
                          'O�U^O�O�O�',
                        ),
                    ],
                  ),
                  if (tournament.status != TournamentStatus.registration) ...[
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: tournament.currentTeams / tournament.maxTeams,
                      backgroundColor: AppColors.accent.withValues(alpha: 0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color color;
    String label;

    switch (tournament.status) {
      case TournamentStatus.registration:
        color = Colors.blue;
        label = 'O�U,O3O�USU,';
        break;
      case TournamentStatus.qualifiers:
        color = Colors.orange;
        label = 'O�U,O�O�U?USO�O�';
        break;
      case TournamentStatus.playoffs:
        color = Colors.purple;
        label = 'O�U,U+U�O�O�USO�';
        break;
      case TournamentStatus.finalStage:
        color = Colors.amber;
        label = 'O�U,U+U�O�US';
        break;
      case TournamentStatus.completed:
        color = Colors.green;
        label = 'U.U�O�U.U,';
        break;
      case TournamentStatus.cancelled:
        color = Colors.red;
        label = 'U.U,O�O�O�';
        break;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      labelStyle: TextStyle(color: color),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.accent),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays} USU^U.';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} O3O�O1Oc';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} O_U,USU,Oc';
    } else {
      return 'O�U�U+';
    }
  }
}
