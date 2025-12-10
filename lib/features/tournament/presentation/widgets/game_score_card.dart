import 'package:flutter/material.dart';
import '../../domain/entities/match.dart';
import '../../../../core/theme/colors.dart';

/// بطاقة نتيجة الجولة
class GameScoreCard extends StatelessWidget {
  final GameResult result;

  const GameScoreCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Game Number
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${result.gameNumber}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Score
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '${result.team1Score}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '-',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  Text(
                    '${result.team2Score}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),

            // Winner Icon
            if (result.winnerTeamId != null)
              const Icon(
                Icons.emoji_events,
                color: AppColors.success,
                size: 24,
              ),

            // Duration
            const SizedBox(width: 8),
            Text(
              _formatDuration(result.duration),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
