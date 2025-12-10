import 'package:equatable/equatable.dart';
import 'link_node.dart';
import 'puzzle_step.dart';
import 'game_type.dart';

class Puzzle extends Equatable {
  final String id;
  final GameType gameType;
  final RepresentationType type;
  final int? level;
  final int? challengeNumber;
  final LinkNode start;
  final LinkNode end;
  final int linksCount;
  final int timeLimit; // total time limit in seconds
  final List<PuzzleStep> steps;
  final String? category;
  final String? difficulty;
  final String? targetSkill;
  final List<String>? tags;
  final String? theme;
  final Map<String, dynamic>? progressionData;
  final Map<String, dynamic>? gameTypeData; // بيانات إضافية خاصة بالنمط

  const Puzzle({
    required this.id,
    this.gameType = GameType.mysteryLink,
    required this.type,
    this.level,
    this.challengeNumber,
    required this.start,
    required this.end,
    required this.linksCount,
    this.timeLimit = 120,
    required this.steps,
    this.category,
    this.difficulty,
    this.targetSkill,
    this.tags,
    this.theme,
    this.progressionData,
    this.gameTypeData,
  });

  bool get isValid {
    if (gameType == GameType.mysteryLink) {
      return steps.length == linksCount &&
          steps.every((step) => step.correctOption != null);
    }
    return steps.isNotEmpty;
  }

  @override
  List<Object?> get props => [
        id,
        gameType,
        type,
        level,
        challengeNumber,
        start,
        end,
        linksCount,
        timeLimit,
        steps,
        category,
        difficulty,
        targetSkill,
        tags,
        theme,
        progressionData,
        gameTypeData,
      ];
}
