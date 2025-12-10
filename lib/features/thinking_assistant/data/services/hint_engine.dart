import '../../../game/domain/entities/link_node.dart';
import '../../../game/domain/entities/puzzle.dart';
import '../../../game/domain/entities/puzzle_step.dart';
import '../../domain/entities/hint_level.dart';

class HintEngine {
  const HintEngine();

  String buildHint({
    required Puzzle puzzle,
    required PuzzleStep step,
    required int currentStep,
    required List<LinkNode> chosenNodes,
    required HintLevel level,
  }) {
    final bridgeStart =
        chosenNodes.isNotEmpty ? chosenNodes.last.label : puzzle.start.label;
    final bridgeEnd = puzzle.end.label;
    final correctNode = step.correctOption?.node;
    final category = puzzle.category ?? 'this theme';

    switch (level) {
      case HintLevel.gentle:
        return 'Think about a connection from $bridgeStart toward $bridgeEnd inside $category.';
      case HintLevel.focused:
        final typeHint = _typeHint(puzzle.type);
        return 'Focus on $typeHint that links $bridgeStart to $bridgeEnd. What concept plays the middle role?';
      case HintLevel.reveal:
        if (correctNode == null) {
          return 'Trace the most direct logical bridge available.';
        }
        final firstLetter =
            correctNode.label.isNotEmpty ? correctNode.label[0] : '?';
        return 'Search for something starting with "$firstLetter" that directly ties $bridgeStart to $bridgeEnd.';
    }
  }

  String _typeHint(RepresentationType type) {
    switch (type) {
      case RepresentationType.text:
        return 'a textual fact';
      case RepresentationType.icon:
        return 'a symbolic idea';
      case RepresentationType.image:
        return 'a visual clue';
      case RepresentationType.event:
        return 'a historical moment';
    }
  }
}
