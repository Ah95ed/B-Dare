import '../../domain/entities/hint_level.dart';
import '../../domain/entities/socratic_question.dart';
import '../../../game/domain/entities/link_node.dart';
import '../../../game/domain/entities/puzzle.dart';

class QuestionGenerator {
  const QuestionGenerator();

  SocraticQuestion buildQuestion({
    required Puzzle puzzle,
    required List<LinkNode> chosenNodes,
    required HintLevel level,
  }) {
    final anchor =
        chosenNodes.isNotEmpty ? chosenNodes.last.label : puzzle.start.label;
    final target = puzzle.end.label;
    switch (level) {
      case HintLevel.gentle:
        return SocraticQuestion(
          prompt: 'What trait could $anchor and $target quietly share?',
          level: level,
          tags: const ['pattern', 'association'],
        );
      case HintLevel.focused:
        return SocraticQuestion(
          prompt:
              'If $anchor could influence $target in two moves, what phenomenon must sit in-between?',
          level: level,
          tags: const ['causality', 'sequence'],
        );
      case HintLevel.reveal:
        return SocraticQuestion(
          prompt:
              'Imagine naming a single bridge from $anchor to $target—what is the most literal option?',
          level: level,
          tags: const ['reveal'],
        );
    }
  }
}
