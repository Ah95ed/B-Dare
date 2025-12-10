import 'package:flutter/material.dart';
import 'package:mystery_link/features/game/domain/entities/link_node.dart';
import 'package:mystery_link/core/theme/colors.dart';
import 'link_representation_display.dart';

class OptionCard extends StatelessWidget {
  final LinkNode node;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;
  final VoidCallback? onTap;

  const OptionCard({
    super.key,
    required this.node,
    this.isSelected = false,
    this.isCorrect = false,
    this.showResult = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    Color? cardColor;
    IconData? icon;

    if (showResult) {
      if (isCorrect) {
        cardColor = AppColors.success.withValues(alpha: 0.2);
        icon = Icons.check_circle;
      } else if (isSelected && !isCorrect) {
        cardColor = AppColors.error.withValues(alpha: 0.2);
        icon = Icons.cancel;
      }
    }

    return Card(
      elevation: isSelected ? 6 : 2,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? const BorderSide(color: AppColors.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: isCorrect ? AppColors.success : AppColors.error,
                  size: 24,
                ),
                const SizedBox(height: 8),
              ],
              LinkRepresentationDisplay(
                node: node,
                locale: locale,
                iconSize: 32,
                imageSize: 72,
                textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
