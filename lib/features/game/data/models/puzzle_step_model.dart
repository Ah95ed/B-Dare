import '../../domain/entities/puzzle_step.dart';
import 'link_node_model.dart';

class StepOptionModel extends StepOption {
  const StepOptionModel({
    required LinkNodeModel super.node,
    required super.isCorrect,
  });

  factory StepOptionModel.fromJson(Map<String, dynamic> json) {
    return StepOptionModel(
      node: LinkNodeModel.fromJson(json['node'] as Map<String, dynamic>),
      isCorrect: json['isCorrect'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'node': (node as LinkNodeModel).toJson(),
      'isCorrect': isCorrect,
    };
  }
}

class PuzzleStepModel extends PuzzleStep {
  const PuzzleStepModel({
    required super.order,
    required List<StepOptionModel> super.options,
    super.timeLimit,
  });

  factory PuzzleStepModel.fromJson(Map<String, dynamic> json) {
    return PuzzleStepModel(
      order: json['order'] as int,
      options: (json['options'] as List)
          .map((e) => StepOptionModel.fromJson(e as Map<String, dynamic>))
          .cast<StepOptionModel>()
          .toList(),
      timeLimit: json['timeLimit'] as int? ?? 12,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'options': options.map((e) => (e as StepOptionModel).toJson()).toList(),
      'timeLimit': timeLimit,
    };
  }
}

