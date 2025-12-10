import 'package:flutter/material.dart';
import '../../domain/entities/bracket.dart';
import '../../domain/entities/match.dart';
import '../../../../core/theme/colors.dart';
import 'match_node.dart';
import 'team_card.dart';

/// عارض شجرة التصفيات
class BracketViewer extends StatefulWidget {
  final TournamentBracket bracket;
  final Function(Match)? onMatchTap;

  const BracketViewer({
    super.key,
    required this.bracket,
    this.onMatchTap,
  });

  @override
  State<BracketViewer> createState() => _BracketViewerState();
}

class _BracketViewerState extends State<BracketViewer> {
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'شجرة التصفيات',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '${widget.bracket.totalRounds} جولات',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
        
        // Bracket Tree
        Expanded(
          child: SingleChildScrollView(
            controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              controller: _verticalController,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildBracketTree(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBracketTree() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.bracket.rounds.asMap().entries.map((entry) {
        final roundIndex = entry.key;
        final round = entry.value;
        return _buildRound(roundIndex + 1, round);
      }).toList(),
    );
  }

  Widget _buildRound(int roundNumber, List<BracketNode> nodes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Round Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'الجولة $roundNumber',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Round Nodes
        ...nodes.asMap().entries.map((entry) {
          final index = entry.key;
          final node = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < nodes.length - 1 ? 32 : 0,
            ),
            child: _buildNode(node),
          );
        }),
      ],
    );
  }

  Widget _buildNode(BracketNode node) {
    if (node.isMatch) {
      final match = widget.bracket.matches[node.matchId!];
      if (match != null) {
        return MatchNode(
          match: match,
          onTap: () => widget.onMatchTap?.call(match),
        );
      }
    } else if (node.isTeam) {
      return TeamCard(team: node.team!);
    }

    // Empty node
    return Container(
      width: 200,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text('TBD'),
      ),
    );
  }
}

