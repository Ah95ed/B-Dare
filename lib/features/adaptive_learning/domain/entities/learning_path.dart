import 'package:equatable/equatable.dart';

class LearningPath extends Equatable {
  final DateTime generatedAt;
  final List<LearningTarget> targets;

  const LearningPath({
    required this.generatedAt,
    required this.targets,
  });

  factory LearningPath.empty() =>
      LearningPath(generatedAt: DateTime.now(), targets: const []);

  @override
  List<Object?> get props => [generatedAt, targets];
}

class LearningTarget extends Equatable {
  final String category;
  final int linksCount;
  final String focus;
  final String nextAction;

  const LearningTarget({
    required this.category,
    required this.linksCount,
    required this.focus,
    required this.nextAction,
  });

  @override
  List<Object?> get props => [category, linksCount, focus, nextAction];
}
