import 'package:flutter/material.dart';

import '../../domain/entities/hint_level.dart';

class HintButton extends StatelessWidget {
  final HintLevel level;
  final ValueChanged<HintLevel> onLevelChanged;
  final VoidCallback onRequest;
  final bool isLoading;

  const HintButton({
    super.key,
    required this.level,
    required this.onLevelChanged,
    required this.onRequest,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: HintLevel.values.map((hintLevel) {
            return ChoiceChip(
              label: Text(hintLevel.label),
              selected: level == hintLevel,
              onSelected: (_) => onLevelChanged(hintLevel),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: isLoading ? null : onRequest,
          icon: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.psychology),
          label: Text(isLoading ? 'Working...' : 'Ask Assistant'),
        ),
      ],
    );
  }
}
