import 'package:flutter/material.dart';
import '../../../game/domain/entities/puzzle.dart';
import '../../../game/domain/entities/link_node.dart';
import '../../../../core/theme/colors.dart';

class PuzzleContextBanner extends StatelessWidget {
  final Puzzle puzzle;
  final String? requestedCategory;
  final String? notice;

  const PuzzleContextBanner({
    super.key,
    required this.puzzle,
    this.requestedCategory,
    this.notice,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final infoPills = <_InfoPillData>[
      _InfoPillData(
        icon: _representationIcon(puzzle.type),
        label: _representationLabel(puzzle.type),
        caption: 'Representation',
      ),
      _InfoPillData(
        icon: Icons.category,
        label: _categoryLabel(),
        caption: 'Theme',
      ),
      _InfoPillData(
        icon: Icons.link,
        label: '${puzzle.linksCount}',
        caption: 'Links',
      ),
      _InfoPillData(
        icon: Icons.timer,
        label: '${puzzle.timeLimit}s',
        caption: 'Time Limit',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: infoPills
              .map((pill) => _InfoPill(
                    data: pill,
                    textStyle: theme.textTheme.bodyMedium,
                  ))
              .toList(),
        ),
        if (notice != null) ...[
          const SizedBox(height: 12),
          _NoticeCard(notice: notice!),
        ],
      ],
    );
  }

  String _categoryLabel() {
    if (puzzle.category != null && puzzle.category!.trim().isNotEmpty) {
      return puzzle.category!;
    }
    if (requestedCategory != null && requestedCategory!.trim().isNotEmpty) {
      return '${requestedCategory!} (requested)';
    }
    return 'Mixed';
  }

  IconData _representationIcon(RepresentationType type) {
    switch (type) {
      case RepresentationType.icon:
        return Icons.auto_awesome;
      case RepresentationType.image:
        return Icons.image;
      case RepresentationType.event:
        return Icons.event;
      case RepresentationType.text:
        return Icons.text_fields;
    }
  }

  String _representationLabel(RepresentationType type) {
    switch (type) {
      case RepresentationType.icon:
        return 'Icon';
      case RepresentationType.image:
        return 'Image';
      case RepresentationType.event:
        return 'Event';
      case RepresentationType.text:
        return 'Text';
    }
  }
}

class _InfoPillData {
  final IconData icon;
  final String label;
  final String caption;

  const _InfoPillData({
    required this.icon,
    required this.label,
    required this.caption,
  });
}

class _InfoPill extends StatelessWidget {
  final _InfoPillData data;
  final TextStyle? textStyle;

  const _InfoPill({
    required this.data,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(data.icon, color: AppColors.primary),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.label,
                style: textStyle?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ) ??
                    const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
              ),
              Text(
                data.caption,
                style: textStyle?.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ) ??
                    const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final String notice;

  const _NoticeCard({required this.notice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.warning),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              notice,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
