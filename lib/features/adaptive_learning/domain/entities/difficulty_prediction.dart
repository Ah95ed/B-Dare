import 'package:equatable/equatable.dart';

class DifficultyPrediction extends Equatable {
  final int recommendedLinks;
  final double confidence;
  final Duration suggestedTimePerStep;
  final List<String> recommendedThemes;
  final List<String> focusAreas;
  final String headline;
  final String rationale;

  const DifficultyPrediction({
    required this.recommendedLinks,
    required this.confidence,
    required this.suggestedTimePerStep,
    required this.recommendedThemes,
    required this.focusAreas,
    required this.headline,
    required this.rationale,
  });

  DifficultyPrediction copyWith({
    int? recommendedLinks,
    double? confidence,
    Duration? suggestedTimePerStep,
    List<String>? recommendedThemes,
    List<String>? focusAreas,
    String? headline,
    String? rationale,
  }) {
    return DifficultyPrediction(
      recommendedLinks: recommendedLinks ?? this.recommendedLinks,
      confidence: confidence ?? this.confidence,
      suggestedTimePerStep: suggestedTimePerStep ?? this.suggestedTimePerStep,
      recommendedThemes: recommendedThemes ?? this.recommendedThemes,
      focusAreas: focusAreas ?? this.focusAreas,
      headline: headline ?? this.headline,
      rationale: rationale ?? this.rationale,
    );
  }

  @override
  List<Object?> get props => [
        recommendedLinks,
        confidence,
        suggestedTimePerStep,
        recommendedThemes,
        focusAreas,
        headline,
        rationale,
      ];
}
