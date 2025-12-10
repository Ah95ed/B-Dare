import '../../../game/domain/entities/link_node.dart';
import '../../../game/domain/entities/puzzle_step.dart';
import '../../../game/domain/entities/puzzle.dart';

class CustomPuzzle {
  final String id;
  final String creatorId;
  final LinkNode start;
  final LinkNode end;
  final List<PuzzleStep> steps;
  final RepresentationType type;
  final String? category;
  final int timeLimit;

  CustomPuzzle({
    required this.id,
    required this.creatorId,
    required this.start,
    required this.end,
    required this.steps,
    required this.type,
    this.category,
    this.timeLimit = 12,
  });

  Puzzle toPuzzle() {
    return Puzzle(
      id: id,
      type: type,
      start: start,
      end: end,
      linksCount: steps.length,
      steps: steps,
      difficulty: _calculateDifficulty(),
      timeLimit: timeLimit,
    );
  }

  String _calculateDifficulty() {
    if (steps.length <= 2) return 'easy';
    if (steps.length <= 5) return 'medium';
    if (steps.length <= 8) return 'hard';
    return 'expert';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creatorId': creatorId,
      'start': {
        'id': start.id,
        'label': start.label,
        'representationType': start.representationType.toString(),
        'labels': start.labels,
      },
      'end': {
        'id': end.id,
        'label': end.label,
        'representationType': end.representationType.toString(),
        'labels': end.labels,
      },
      'steps': steps.map((step) => {
            'order': step.order,
            'timeLimit': step.timeLimit,
            'options': step.options.map((option) => {
                  'node': {
                    'id': option.node.id,
                    'label': option.node.label,
                    'representationType': option.node.representationType.toString(),
                    'labels': option.node.labels,
                  },
                  'isCorrect': option.isCorrect,
                }).toList(),
          }).toList(),
      'type': type.toString(),
      'category': category,
      'timeLimit': timeLimit,
    };
  }

  factory CustomPuzzle.fromJson(Map<String, dynamic> json) {
    return CustomPuzzle(
      id: json['id'],
      creatorId: json['creatorId'],
      start: LinkNode(
        id: json['start']['id'],
        label: json['start']['label'],
        representationType: _parseRepresentationType(json['start']['representationType']),
        labels: Map<String, String>.from(json['start']['labels'] ?? {}),
      ),
      end: LinkNode(
        id: json['end']['id'],
        label: json['end']['label'],
        representationType: _parseRepresentationType(json['end']['representationType']),
        labels: Map<String, String>.from(json['end']['labels'] ?? {}),
      ),
      steps: (json['steps'] as List).map((step) {
        return PuzzleStep(
          order: step['order'],
          timeLimit: step['timeLimit'] ?? 12,
          options: (step['options'] as List).map((option) {
            return StepOption(
              node: LinkNode(
                id: option['node']['id'],
                label: option['node']['label'],
                representationType: _parseRepresentationType(option['node']['representationType']),
                labels: Map<String, String>.from(option['node']['labels'] ?? {}),
              ),
              isCorrect: option['isCorrect'] ?? false,
            );
          }).toList(),
        );
      }).toList(),
      type: _parseRepresentationType(json['type']),
      category: json['category'],
      timeLimit: json['timeLimit'] ?? 12,
    );
  }

  static RepresentationType _parseRepresentationType(String? type) {
    if (type == null) return RepresentationType.text;
    return RepresentationType.values.firstWhere(
      (e) => e.toString() == type,
      orElse: () => RepresentationType.text,
    );
  }
}

