part of 'thinking_assistant_bloc.dart';

abstract class ThinkingAssistantEvent extends Equatable {
  const ThinkingAssistantEvent();

  @override
  List<Object?> get props => [];
}

class ThinkingAssistantHintRequested extends ThinkingAssistantEvent {
  final Puzzle puzzle;
  final PuzzleStep step;
  final List<LinkNode> chosenNodes;

  const ThinkingAssistantHintRequested({
    required this.puzzle,
    required this.step,
    required this.chosenNodes,
  });

  @override
  List<Object?> get props => [puzzle, step, chosenNodes];
}

class ThinkingAssistantLevelChanged extends ThinkingAssistantEvent {
  final HintLevel level;

  const ThinkingAssistantLevelChanged(this.level);

  @override
  List<Object?> get props => [level];
}

class ThinkingAssistantReset extends ThinkingAssistantEvent {
  const ThinkingAssistantReset();
}
