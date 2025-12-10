import 'package:equatable/equatable.dart';

import '../../../game/domain/entities/link_node.dart';

/// Immutable snapshot for the player's cognitive performance.
class PlayerCognitiveProfile extends Equatable {
  final int totalSessions;
  final double winRate;
  final double perfectRate;
  final double averageLinks;
  final double averageTimePerLink;
  final int recommendedLinks;
  final RepresentationType preferredRepresentation;
  final List<String> strongDomains;
  final List<String> focusAreas;
  final DateTime updatedAt;

  const PlayerCognitiveProfile({
    required this.totalSessions,
    required this.winRate,
    required this.perfectRate,
    required this.averageLinks,
    required this.averageTimePerLink,
    required this.recommendedLinks,
    required this.preferredRepresentation,
    required this.strongDomains,
    required this.focusAreas,
    required this.updatedAt,
  });

  factory PlayerCognitiveProfile.initial() => PlayerCognitiveProfile(
        totalSessions: 0,
        winRate: 0,
        perfectRate: 0,
        averageLinks: 0,
        averageTimePerLink: 0,
        recommendedLinks: 3,
        preferredRepresentation: RepresentationType.text,
        strongDomains: const [],
        focusAreas: const [],
        updatedAt: DateTime.now(),
      );

  PlayerCognitiveProfile copyWith({
    int? totalSessions,
    double? winRate,
    double? perfectRate,
    double? averageLinks,
    double? averageTimePerLink,
    int? recommendedLinks,
    RepresentationType? preferredRepresentation,
    List<String>? strongDomains,
    List<String>? focusAreas,
    DateTime? updatedAt,
  }) {
    return PlayerCognitiveProfile(
      totalSessions: totalSessions ?? this.totalSessions,
      winRate: winRate ?? this.winRate,
      perfectRate: perfectRate ?? this.perfectRate,
      averageLinks: averageLinks ?? this.averageLinks,
      averageTimePerLink: averageTimePerLink ?? this.averageTimePerLink,
      recommendedLinks: recommendedLinks ?? this.recommendedLinks,
      preferredRepresentation:
          preferredRepresentation ?? this.preferredRepresentation,
      strongDomains: strongDomains ?? this.strongDomains,
      focusAreas: focusAreas ?? this.focusAreas,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        totalSessions,
        winRate,
        perfectRate,
        averageLinks,
        averageTimePerLink,
        recommendedLinks,
        preferredRepresentation,
        strongDomains,
        focusAreas,
        updatedAt,
      ];
}
