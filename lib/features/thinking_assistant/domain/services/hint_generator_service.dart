import '../../../game/domain/entities/puzzle.dart';
import '../../../game/domain/entities/puzzle_step.dart';
import '../../../game/domain/entities/link_node.dart';
import '../entities/hint_level.dart';
import '../entities/thinking_insight.dart';
import '../entities/thinking_path.dart';
import '../../data/services/hint_engine.dart';
import '../../data/services/question_generator.dart';

class HintGeneratorService {
  final HintEngine _hintEngine;
  final QuestionGenerator _questionGenerator;

  const HintGeneratorService({
    HintEngine? hintEngine,
    QuestionGenerator? questionGenerator,
  })  : _hintEngine = hintEngine ?? const HintEngine(),
        _questionGenerator = questionGenerator ?? const QuestionGenerator();

  Future<ThinkingInsight> generate({
    required Puzzle puzzle,
    required PuzzleStep step,
    required List<LinkNode> chosenNodes,
    HintLevel level = HintLevel.gentle,
  }) async {
    final hintText = _hintEngine.buildHint(
      puzzle: puzzle,
      step: step,
      currentStep: step.order,
      chosenNodes: chosenNodes,
      level: level,
    );
    final question = _questionGenerator.buildQuestion(
      puzzle: puzzle,
      chosenNodes: chosenNodes,
      level: level,
    );
    final suggestedNode = step.correctOption?.node;
    final path = _buildThinkingPath(puzzle, chosenNodes, level);

    return ThinkingInsight(
      level: level,
      hintText: hintText,
      question: question,
      path: path,
      suggestedNode: level == HintLevel.reveal ? suggestedNode : null,
    );
  }

  ThinkingPath _buildThinkingPath(
    Puzzle puzzle,
    List<LinkNode> chosenNodes,
    HintLevel level,
  ) {
    final current =
        chosenNodes.isNotEmpty ? chosenNodes.last.label : puzzle.start.label;
    final target = puzzle.end.label;

    final steps = <ThinkingStep>[
      ThinkingStep(
        label: 'Compare context',
        action: 'List two traits shared by $current and $target.',
        rationale: 'Shared attributes often highlight the missing bridge.',
      ),
      const ThinkingStep(
        label: 'Check direction',
        action: 'Decide if the bridge is causal, temporal, or categorical.',
        rationale: 'Knowing the link type shrinks the option space.',
      ),
      if (level != HintLevel.gentle)
        const ThinkingStep(
          label: 'Name a candidate',
          action: 'Pick one concrete concept to test against the options.',
          rationale: 'Commit to a hypothesis before reading the answers.',
        ),
    ];
    return ThinkingPath(steps: steps);
  }
}
