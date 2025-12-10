import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/puzzle.dart';
import '../../domain/entities/game_type.dart';
import 'link_node_model.dart';
import 'puzzle_step_model.dart';

class GameTypeConverter implements JsonConverter<GameType, String> {
  const GameTypeConverter();

  @override
  GameType fromJson(String json) {
    return GameTypeExtension.fromString(json) ?? GameType.mysteryLink;
  }

  @override
  String toJson(GameType object) {
    return object.value;
  }
}

@JsonSerializable(explicitToJson: true)
class PuzzleModel extends Puzzle {
  const PuzzleModel({
    required super.id,
    @GameTypeConverter() super.gameType = GameType.mysteryLink,
    required super.type,
    super.level,
    super.challengeNumber,
    required LinkNodeModel super.start,
    required LinkNodeModel super.end,
    required super.linksCount,
    super.timeLimit,
    required List<PuzzleStepModel> super.steps,
    super.category,
    super.difficulty,
    super.targetSkill,
    super.tags,
    super.theme,
    super.progressionData,
    super.gameTypeData,
  });

  factory PuzzleModel.fromJson(Map<String, dynamic> json) {
    return PuzzleModel(
      id: json['id'] as String,
      gameType: const GameTypeConverter().fromJson(
        json['gameType'] as String? ?? 'mysteryLink',
      ),
      type: const RepresentationTypeConverter().fromJson(
        json['type'] as String? ?? 'text',
      ),
      level: json['level'] as int?,
      challengeNumber: json['challengeNumber'] as int?,
      start: LinkNodeModel.fromJson(json['start'] as Map<String, dynamic>),
      end: LinkNodeModel.fromJson(json['end'] as Map<String, dynamic>),
      linksCount: json['linksCount'] as int,
      timeLimit: json['timeLimit'] as int? ?? 120,
      steps: (json['steps'] as List)
          .map((e) => PuzzleStepModel.fromJson(e as Map<String, dynamic>))
          .cast<PuzzleStepModel>()
          .toList(),
      category: json['category'] as String?,
      difficulty: json['difficulty'] as String?,
      targetSkill: json['targetSkill'] as String?,
      tags: (json['tags'] as List?)?.cast<String>(),
      theme: json['theme'] as String?,
      progressionData: json['progressionData'] != null
          ? Map<String, dynamic>.from(json['progressionData'] as Map)
          : null,
      gameTypeData: json['gameTypeData'] != null
          ? Map<String, dynamic>.from(json['gameTypeData'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gameType': const GameTypeConverter().toJson(gameType),
      'type': const RepresentationTypeConverter().toJson(type),
      if (level != null) 'level': level,
      if (challengeNumber != null) 'challengeNumber': challengeNumber,
      'start': (start as LinkNodeModel).toJson(),
      'end': (end as LinkNodeModel).toJson(),
      'linksCount': linksCount,
      'timeLimit': timeLimit,
      'steps': steps.map((e) => (e as PuzzleStepModel).toJson()).toList(),
      'category': category,
      'difficulty': difficulty,
      if (targetSkill != null) 'targetSkill': targetSkill,
      if (tags != null) 'tags': tags,
      if (theme != null) 'theme': theme,
      if (progressionData != null) 'progressionData': progressionData,
      if (gameTypeData != null) 'gameTypeData': gameTypeData,
    };
  }
}
