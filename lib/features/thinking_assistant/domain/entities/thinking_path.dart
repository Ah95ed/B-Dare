import 'package:equatable/equatable.dart';

class ThinkingPath extends Equatable {
  final List<ThinkingStep> steps;

  const ThinkingPath({required this.steps});

  factory ThinkingPath.empty() => const ThinkingPath(steps: []);

  @override
  List<Object?> get props => [steps];
}

class ThinkingStep extends Equatable {
  final String label;
  final String action;
  final String rationale;

  const ThinkingStep({
    required this.label,
    required this.action,
    required this.rationale,
  });

  @override
  List<Object?> get props => [label, action, rationale];
}
