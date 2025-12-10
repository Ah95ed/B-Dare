import '../../../game/domain/entities/link_node.dart';
import '../../../progression/domain/entities/game_result.dart';

class PerformanceSampleModel {
  final String puzzleId;
  final String? category;
  final RepresentationType representationType;
  final int linksCount;
  final int score;
  final Duration timeSpent;
  final bool isWin;
  final bool isPerfect;
  final DateTime completedAt;

  PerformanceSampleModel({
    required this.puzzleId,
    required this.category,
    required this.representationType,
    required this.linksCount,
    required this.score,
    required this.timeSpent,
    required this.isWin,
    required this.isPerfect,
    required this.completedAt,
  });

  factory PerformanceSampleModel.fromResult(GameResult result) {
    return PerformanceSampleModel(
      puzzleId: result.puzzle.id,
      category: result.puzzle.category,
      representationType: result.puzzle.type,
      linksCount: result.puzzle.linksCount,
      score: result.score,
      timeSpent: result.timeSpent,
      isWin: result.isWin,
      isPerfect: result.isPerfect,
      completedAt: result.completedAt,
    );
  }

  factory PerformanceSampleModel.fromJson(Map<String, dynamic> json) {
    return PerformanceSampleModel(
      puzzleId: json['puzzleId'] as String? ?? '',
      category: json['category'] as String?,
      representationType: _parseRepresentation(json['representationType']),
      linksCount: json['linksCount'] as int? ?? 0,
      score: json['score'] as int? ?? 0,
      timeSpent: Duration(seconds: json['timeSpentSeconds'] as int? ?? 0),
      isWin: json['isWin'] as bool? ?? false,
      isPerfect: json['isPerfect'] as bool? ?? false,
      completedAt: DateTime.fromMillisecondsSinceEpoch(
        json['completedAt'] as int? ?? 0,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'puzzleId': puzzleId,
      'category': category,
      'representationType': representationType.name,
      'linksCount': linksCount,
      'score': score,
      'timeSpentSeconds': timeSpent.inSeconds,
      'isWin': isWin,
      'isPerfect': isPerfect,
      'completedAt': completedAt.millisecondsSinceEpoch,
    };
  }

  static RepresentationType _parseRepresentation(dynamic raw) {
    final value = raw as String? ?? RepresentationType.text.name;
    return RepresentationType.values.firstWhere(
      (element) => element.name == value,
      orElse: () => RepresentationType.text,
    );
  }
}
