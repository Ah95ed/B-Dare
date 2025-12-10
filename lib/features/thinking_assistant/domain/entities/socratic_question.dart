import 'package:equatable/equatable.dart';

import 'hint_level.dart';

class SocraticQuestion extends Equatable {
  final String prompt;
  final HintLevel level;
  final List<String> tags;

  const SocraticQuestion({
    required this.prompt,
    required this.level,
    required this.tags,
  });

  @override
  List<Object?> get props => [prompt, level, tags];
}
