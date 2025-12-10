import 'package:equatable/equatable.dart';

import '../../../game/domain/entities/link_node.dart';
import 'hint_level.dart';
import 'socratic_question.dart';
import 'thinking_path.dart';

class ThinkingInsight extends Equatable {
  final HintLevel level;
  final String hintText;
  final SocraticQuestion? question;
  final ThinkingPath path;
  final LinkNode? suggestedNode;

  const ThinkingInsight({
    required this.level,
    required this.hintText,
    this.question,
    required this.path,
    this.suggestedNode,
  });

  @override
  List<Object?> get props => [level, hintText, question, path, suggestedNode];
}
