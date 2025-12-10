import 'package:flutter/material.dart';

import '../../domain/entities/difficulty_prediction.dart';
import '../../domain/entities/learning_path.dart';
import '../../domain/entities/player_cognitive_profile.dart';

class DifficultyIndicator extends StatelessWidget {
  final PlayerCognitiveProfile profile;
  final DifficultyPrediction prediction;
  final LearningPath? learningPath;
  final VoidCallback? onApplyRecommendation;

  const DifficultyIndicator({
    super.key,
    required this.profile,
    required this.prediction,
    this.learningPath,
    this.onApplyRecommendation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final confidencePercent = (prediction.confidence * 100).clamp(0, 100);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prediction.headline,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        prediction.rationale,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color
                              ?.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                if (onApplyRecommendation != null)
                  FilledButton(
                    onPressed: onApplyRecommendation,
                    child: Text('Use ${prediction.recommendedLinks} links'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _StatTile(
                  label: 'Recommended links',
                  value: prediction.recommendedLinks.toString(),
                ),
                _StatTile(
                  label: 'Win rate',
                  value: '${(profile.winRate * 100).toStringAsFixed(0)}%',
                ),
                _StatTile(
                  label: 'Avg time/link',
                  value: '${profile.averageTimePerLink.toStringAsFixed(1)}s',
                ),
                _StatTile(
                  label: 'Confidence',
                  value: '${confidencePercent.toStringAsFixed(0)}%',
                ),
              ],
            ),
            if (prediction.focusAreas.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Focus areas',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: prediction.focusAreas
                    .map((focus) => Chip(label: Text(focus)))
                    .toList(),
              ),
            ],
            if (learningPath != null && learningPath!.targets.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'Next learning path',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Column(
                children: learningPath!.targets.map((target) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      child: Text('${target.linksCount}'),
                    ),
                    title: Text(target.category),
                    subtitle: Text(target.focus),
                    trailing: Text(target.nextAction),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;

  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
