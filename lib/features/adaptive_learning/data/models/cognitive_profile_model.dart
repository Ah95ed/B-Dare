import '../../../game/domain/entities/link_node.dart';
import '../../domain/entities/player_cognitive_profile.dart';

class CognitiveProfileModel extends PlayerCognitiveProfile {
  const CognitiveProfileModel({
    required super.totalSessions,
    required super.winRate,
    required super.perfectRate,
    required super.averageLinks,
    required super.averageTimePerLink,
    required super.recommendedLinks,
    required super.preferredRepresentation,
    required super.strongDomains,
    required super.focusAreas,
    required super.updatedAt,
  });

  factory CognitiveProfileModel.fromJson(Map<String, dynamic> json) {
    return CognitiveProfileModel(
      totalSessions: json['totalSessions'] as int? ?? 0,
      winRate: (json['winRate'] as num?)?.toDouble() ?? 0,
      perfectRate: (json['perfectRate'] as num?)?.toDouble() ?? 0,
      averageLinks: (json['averageLinks'] as num?)?.toDouble() ?? 0,
      averageTimePerLink:
          (json['averageTimePerLink'] as num?)?.toDouble() ?? 0,
      recommendedLinks: json['recommendedLinks'] as int? ?? 3,
      preferredRepresentation:
          _parseRepresentation(json['preferredRepresentation'] as String?),
      strongDomains: List<String>.from(json['strongDomains'] ?? const []),
      focusAreas: List<String>.from(json['focusAreas'] ?? const []),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        json['updatedAt'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalSessions': totalSessions,
      'winRate': winRate,
      'perfectRate': perfectRate,
      'averageLinks': averageLinks,
      'averageTimePerLink': averageTimePerLink,
      'recommendedLinks': recommendedLinks,
      'preferredRepresentation': preferredRepresentation.name,
      'strongDomains': strongDomains,
      'focusAreas': focusAreas,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  static RepresentationType _parseRepresentation(String? raw) {
    if (raw == null) {
      return RepresentationType.text;
    }
    return RepresentationType.values.firstWhere(
      (type) => type.name == raw,
      orElse: () => RepresentationType.text,
    );
  }
}
