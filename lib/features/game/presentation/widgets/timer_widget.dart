import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class TimerWidget extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;
  final bool isWarning;

  const TimerWidget({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final progress = remainingSeconds / totalSeconds;
    final isLowTime = remainingSeconds <= 10;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: AppColors.textSecondary.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isLowTime ? AppColors.error : AppColors.primary,
                    ),
                  ),
                ),
                Text(
                  '$remainingSeconds',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isLowTime ? AppColors.error : AppColors.primary,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Time Remaining',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

