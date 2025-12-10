import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/team.dart';
import '../bloc/tournament_bloc.dart';
import '../bloc/tournament_event.dart';
import '../bloc/tournament_state.dart';
import '../../../../core/theme/colors.dart';
import '../../../../shared/widgets/loading_widget.dart';

/// شاشة إدارة الفريق في البطولة
class TeamManagementScreen extends StatefulWidget {
  final String tournamentId;
  final Team team;

  const TeamManagementScreen({
    super.key,
    required this.tournamentId,
    required this.team,
  });

  @override
  State<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends State<TeamManagementScreen> {
  @override
  void initState() {
    super.initState();
    // جلب معلومات الفريق
    context.read<TournamentBloc>().add(
          FetchTournamentTeams(widget.tournamentId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.team.name),
      ),
      body: BlocBuilder<TournamentBloc, TournamentState>(
        builder: (context, state) {
          if (state is TournamentLoading) {
            return const LoadingWidget();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Team Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: AppColors.primary,
                              child: widget.team.avatarUrl != null
                                  ? ClipOval(
                                      child: Image.network(
                                        widget.team.avatarUrl!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Text(
                                      widget.team.name[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.team.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  if (widget.team.seed != null)
                                    Chip(
                                      label: Text('#${widget.team.seed}'),
                                      backgroundColor:
                                          AppColors.accent.withValues(alpha: 0.2),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Stats
                        Row(
                          children: [
                            _buildStatItem(
                              context,
                              Icons.people,
                              '${widget.team.memberCount}',
                              'أعضاء',
                            ),
                            const SizedBox(width: 16),
                            _buildStatItem(
                              context,
                              Icons.emoji_events,
                              '${widget.team.stats.matchesWon}',
                              'انتصارات',
                            ),
                            const SizedBox(width: 16),
                            _buildStatItem(
                              context,
                              Icons.percent,
                              '${(widget.team.stats.winRate * 100).toStringAsFixed(0)}%',
                              'نسبة الفوز',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Members Section
                Text(
                  'الأعضاء',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                ...widget.team.memberIds.map((memberId) {
                  final isCaptain = memberId == widget.team.captainId;
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(memberId[0].toUpperCase()),
                    ),
                    title: Text(memberId),
                    trailing: isCaptain
                        ? Chip(
                            label: const Text('قائد'),
                            backgroundColor:
                                AppColors.accent.withValues(alpha: 0.2),
                          )
                        : null,
                  );
                }),
                
                const SizedBox(height: 24),
                
                // Preferred Time Slots
                Text(
                  'الأوقات المفضلة',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                if (widget.team.preferredTimeSlots.isEmpty)
                  const Text('لا توجد أوقات مفضلة')
                else
                  ...widget.team.preferredTimeSlots.map((time) => ListTile(
                        leading: const Icon(Icons.schedule),
                        title: Text(_formatDateTime(time)),
                      )),
                
                const SizedBox(height: 24),
                
                // Actions
                if (widget.team.captainId == 'current_user_id') ...[
                  // TODO: Get from auth
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Edit team
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تعديل الفريق - قريباً')),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('تعديل الفريق'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      _showLeaveTeamDialog(context);
                    },
                    icon: const Icon(Icons.exit_to_app),
                    label: const Text('مغادرة الفريق'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLeaveTeamDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مغادرة الفريق'),
        content: const Text('هل أنت متأكد من مغادرة الفريق؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              context.read<TournamentBloc>().add(
                    UnregisterTeam(
                      tournamentId: widget.tournamentId,
                      teamId: widget.team.id,
                    ),
                  );
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'مغادرة',
              style: TextStyle(color: AppColors.error),
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

