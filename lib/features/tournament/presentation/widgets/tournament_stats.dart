import 'package:flutter/material.dart';
import '../../domain/entities/tournament.dart';
import '../../../../core/theme/colors.dart';
import '../../../../l10n/app_localizations.dart';

/// إحصائيات البطولة
class TournamentStats extends StatelessWidget {
  final Tournament tournament;

  const TournamentStats({
    super.key,
    required this.tournament,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            l10n.tournamentStatsTeams,
            '${tournament.currentTeams}/${tournament.maxTeams}',
            Icons.people,
            AppColors.accent,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            context,
            l10n.tournamentStatsStages,
            '${tournament.stages.length}',
            Icons.layers,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            context,
            l10n.tournamentStatsType,
            _getTypeName(context, tournament.type),
            Icons.category,
            Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
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
    );
  }

  String _getTypeName(BuildContext context, TournamentType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case TournamentType.singleElimination:
        return l10n.tournamentTypeSingleElimination;
      case TournamentType.doubleElimination:
        return l10n.tournamentTypeDoubleElimination;
      case TournamentType.swiss:
        return l10n.tournamentTypeSwiss;
      case TournamentType.roundRobin:
        return l10n.tournamentTypeRoundRobin;
    }
  }
}

