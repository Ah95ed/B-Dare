import 'package:flutter/material.dart';

import '../../domain/entities/thinking_insight.dart';

class ThinkingAnalysisWidget extends StatelessWidget {
  final ThinkingInsight insight;

  const ThinkingAnalysisWidget({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assistant (${insight.level.label})',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(insight.hintText),
            if (insight.question != null) ...[
              const SizedBox(height: 12),
              Text(
                'Try this question:',
                style: theme.textTheme.titleSmall,
              ),
              Text(insight.question!.prompt),
            ],
            if (insight.path.steps.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Suggested moves',
                style: theme.textTheme.titleSmall,
              ),
              ...insight.path.steps.map(
                (step) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('• ${step.action}'),
                ),
              ),
            ],
            if (insight.suggestedNode != null) ...[
              const SizedBox(height: 12),
              Text(
                'Direct hint: ${insight.suggestedNode!.label}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
