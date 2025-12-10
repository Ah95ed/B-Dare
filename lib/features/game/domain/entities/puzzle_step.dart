import 'package:equatable/equatable.dart';
import 'link_node.dart';

class StepOption extends Equatable {
  final LinkNode node;
  final bool isCorrect;

  const StepOption({
    required this.node,
    required this.isCorrect,
  });

  @override
  List<Object?> get props => [node, isCorrect];
}

class PuzzleStep extends Equatable {
  final int order;
  final List<StepOption> options;
  final int timeLimit; // in seconds

  const PuzzleStep({
    required this.order,
    required this.options,
    this.timeLimit = 12,
  });

  StepOption? get correctOption {
    try {
      return options.firstWhere((option) => option.isCorrect);
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [order, options, timeLimit];
}

