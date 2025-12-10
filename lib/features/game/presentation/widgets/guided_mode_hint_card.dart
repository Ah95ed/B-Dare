import 'package:flutter/material.dart';
import '../../../../core/constants/game_constants.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/entities/puzzle.dart';
import '../../domain/entities/link_node.dart';

class GuidedModeHintCard extends StatefulWidget {
  final Puzzle puzzle;
  final int currentStep;
  final Locale locale;
  final ValueChanged<int>? onHintRequested;
  final ValueChanged<Map<String, dynamic>>? onPracticeRequested;

  const GuidedModeHintCard({
    super.key,
    required this.puzzle,
    required this.currentStep,
    required this.locale,
    this.onHintRequested,
    this.onPracticeRequested,
  });

  @override
  State<GuidedModeHintCard> createState() => _GuidedModeHintCardState();
}

class _GuidedModeHintCardState extends State<GuidedModeHintCard> {
  bool _showStepTip = false;

  @override
  void didUpdateWidget(covariant GuidedModeHintCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _showStepTip = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeCode = widget.locale.languageCode;
    final baseText = _guidedHeadline(localeCode);
    final tip = _stepTip(localeCode);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: AppColors.info),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  baseText,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _typeHint(localeCode),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          if (tip != null) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                final newValue = !_showStepTip;
                setState(() => _showStepTip = newValue);
                if (newValue) {
                  widget.onHintRequested?.call(widget.currentStep);
                }
              },
              icon: Icon(_showStepTip ? Icons.visibility_off : Icons.visibility),
              label: Text(_showStepTip
                  ? _hideHintLabel(localeCode)
                  : _showHintLabel(localeCode)),
            ),
            if (_showStepTip) ...[
              const SizedBox(height: 10),
              Text(
                tip,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
            const SizedBox(height: 6),
            Text(
              _penaltyNote(localeCode),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              final sample = _buildSamplePuzzle();
              widget.onPracticeRequested?.call(sample);
            },
            icon: const Icon(Icons.replay),
            label: Text(
              _practiceLabel(localeCode),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  String _guidedHeadline(String code) {
    final current = widget.currentStep;
    final total = widget.puzzle.linksCount;
    final start = widget.puzzle.start.getLocalizedLabel(code);
    final end = widget.puzzle.end.getLocalizedLabel(code);
    if (code == 'ar') {
      return 'اربط $start إلى $end خطوة بخطوة ($current/$total).';
    }
    return 'Link $start to $end step-by-step ($current/$total).';
  }

  String _typeHint(String code) {
    final type = widget.puzzle.type;
    if (code == 'ar') {
      return _arabicHint(type);
    }
    return _englishHint(type);
  }

  String _arabicHint(RepresentationType type) {
    switch (type) {
      case RepresentationType.icon:
        return 'ابحث عن رموز أو أيقونات مشتركة بين الخيارات.';
      case RepresentationType.image:
        return 'قارِن الصور والبيئات لاكتشاف الرابط.';
      case RepresentationType.event:
        return 'فكّر في الأحداث أو التسلسل الزمني الذي يربط بين العناصر.';
      case RepresentationType.text:
        return 'اقرأ الكلمات وابحث عن علاقة واضحة أو معنى مشترك.';
    }
  }

  String _englishHint(RepresentationType type) {
    switch (type) {
      case RepresentationType.icon:
        return 'Look for shared symbols or categories between icons.';
      case RepresentationType.image:
        return 'Compare visuals and context clues within the images.';
      case RepresentationType.event:
        return 'Think about timelines or causes that connect the events.';
      case RepresentationType.text:
        return 'Read the words and search for a common idea or meaning.';
    }
  }

  String _showHintLabel(String code) {
    return code == 'ar' ? 'عرض تلميح الخطوة' : 'Show step hint';
  }

  String _hideHintLabel(String code) {
    return code == 'ar' ? 'إخفاء التلميح' : 'Hide hint';
  }

  String? _stepTip(String code) {
    if (widget.currentStep <= 0 ||
        widget.currentStep > widget.puzzle.steps.length) {
      return null;
    }
    final correctOption =
        widget.puzzle.steps[widget.currentStep - 1].correctOption;
    if (correctOption == null) return null;
    final label = correctOption.node.getLocalizedLabel(code);
    if (code == 'ar') {
      return 'فكّر في "$label" كحلقة الربط القادمة.';
    }
    return 'Consider "$label" as the next bridge in your chain.';
  }

  String _penaltyNote(String code) {
    final percent = (100 - (GameConstants.hintPenaltyMultiplier * 100)).round();
    if (code == 'ar') {
      return 'استخدام هذا التلميح يقلل نقاط هذه الخطوة بنسبة $percent٪.';
    }
    return 'Using this hint reduces this step\'s points by $percent%.';
  }

  String _practiceLabel(String code) {
    return code == 'ar' ? 'إعادة لغز تدريبي' : 'Replay sample puzzle';
  }
}

Map<String, dynamic> _buildSamplePuzzle() {
  return {
    'id': 'guided_sample_${DateTime.now().millisecondsSinceEpoch}',
    'type': 'text',
    'linksCount': 2,
    'timeLimit': 45,
    'start': {
      'id': 'guided_start',
      'label': 'Sun',
      'representationType': 'text',
      'labels': {'en': 'Sun', 'ar': 'الشمس'}
    },
    'end': {
      'id': 'guided_end',
      'label': 'Harvest',
      'representationType': 'text',
      'labels': {'en': 'Harvest', 'ar': 'الحصاد'}
    },
    'steps': [
      {
        'order': 1,
        'timeLimit': 12,
        'options': [
          {
            'node': {
              'id': 'guided_clouds',
              'label': 'Clouds',
              'representationType': 'text',
              'labels': {'en': 'Clouds', 'ar': 'الغيوم'}
            },
            'isCorrect': true
          },
          {
            'node': {
              'id': 'guided_rocks',
              'label': 'Rocks',
              'representationType': 'text',
              'labels': {'en': 'Rocks', 'ar': 'الصخور'}
            },
            'isCorrect': false
          },
        ],
      },
      {
        'order': 2,
        'timeLimit': 12,
        'options': [
          {
            'node': {
              'id': 'guided_rain',
              'label': 'Rain',
              'representationType': 'text',
              'labels': {'en': 'Rain', 'ar': 'المطر'}
            },
            'isCorrect': true
          },
          {
            'node': {
              'id': 'guided_metal',
              'label': 'Metal',
              'representationType': 'text',
              'labels': {'en': 'Metal', 'ar': 'المعدن'}
            },
            'isCorrect': false
          },
        ],
      },
    ],
  };
}
