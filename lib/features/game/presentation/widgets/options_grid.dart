import 'package:flutter/material.dart';
import 'package:mystery_link/features/game/domain/entities/puzzle_step.dart';
import 'package:mystery_link/features/game/domain/entities/link_node.dart';
import 'option_card.dart';

class OptionsGrid extends StatelessWidget {
  final PuzzleStep step;
  final LinkNode? selectedNode;
  final bool showResult;
  final ValueChanged<LinkNode> onOptionSelected;

  const OptionsGrid({
    super.key,
    required this.step,
    this.selectedNode,
    this.showResult = false,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: step.options.length,
      itemBuilder: (context, index) {
        final option = step.options[index];
        final isSelected = selectedNode?.id == option.node.id;
        final isCorrect = option.isCorrect;

        return OptionCard(
          node: option.node,
          isSelected: isSelected,
          isCorrect: isCorrect,
          showResult: showResult,
          onTap: showResult ? null : () => onOptionSelected(option.node),
        );
      },
    );
  }
}

