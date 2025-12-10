import 'package:flutter/material.dart';

import '../../domain/entities/thinking_insight.dart';

class SocraticDialog extends StatelessWidget {
  final ThinkingInsight insight;

  const SocraticDialog({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thinking Assistant'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            insight.hintText,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          if (insight.question != null) ...[
            Text(
              'Socratic question',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(insight.question!.prompt),
            const SizedBox(height: 12),
          ],
          if (insight.path.steps.isNotEmpty) ...[
            Text(
              'Thinking path',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            ...insight.path.steps.map(
              (step) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(step.label),
                subtitle: Text('${step.action}\n${step.rationale}'),
              ),
            ),
          ],
          if (insight.suggestedNode != null) ...[
            const SizedBox(height: 12),
            Text(
              'Direct bridge: ${insight.suggestedNode!.label}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
