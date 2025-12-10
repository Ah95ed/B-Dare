import 'package:flutter/material.dart';
import 'package:mystery_link/features/game/domain/entities/link_node.dart';
import 'package:mystery_link/core/theme/colors.dart';
import 'link_representation_display.dart';

class PuzzleHeader extends StatelessWidget {
  final LinkNode startNode;
  final LinkNode endNode;
  final List<LinkNode>? chosenNodes;

  const PuzzleHeader({
    super.key,
    required this.startNode,
    required this.endNode,
    this.chosenNodes,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Start and End Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildNodeCard(
                  context,
                  startNode,
                  AppColors.cardStart,
                  'Start',
                  locale,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNodeCard(
                  context,
                  endNode,
                  AppColors.cardEnd,
                  'End',
                  locale,
                ),
              ),
            ],
          ),

          // Chosen Nodes Chain
          if (chosenNodes != null && chosenNodes!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildChain(context, locale),
          ],
        ],
      ),
    );
  }

  Widget _buildNodeCard(
    BuildContext context,
    LinkNode node,
    Color color,
    String label,
    String locale,
  ) {
    return Card(
      elevation: 4,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
            ),
            const SizedBox(height: 8),
            LinkRepresentationDisplay(
              node: node,
              locale: locale,
              iconSize: 40,
              imageSize: 80,
              textStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChain(BuildContext context, String locale) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: [
        ...chosenNodes!.map((node) => _buildChainNode(context, node, locale)),
        if (chosenNodes!.length < 10)
          const Icon(
            Icons.arrow_forward,
            color: AppColors.textSecondary,
            size: 20,
          ),
      ],
    );
  }

  Widget _buildChainNode(BuildContext context, LinkNode node, String locale) {
    return Chip(
      label: LinkRepresentationDisplay(
        node: node,
        locale: locale,
        iconSize: 18,
        imageSize: 32,
        textStyle: Theme.of(context).textTheme.bodySmall,
      ),
      backgroundColor: AppColors.cardLink.withValues(alpha: 0.2),
      side: const BorderSide(color: AppColors.cardLink),
    );
  }
}
