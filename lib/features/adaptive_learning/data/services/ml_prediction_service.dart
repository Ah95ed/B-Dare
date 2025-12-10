import '../../../../core/constants/game_constants.dart';
import '../../domain/entities/difficulty_prediction.dart';
import '../../domain/entities/learning_path.dart';
import '../../domain/entities/player_cognitive_profile.dart';

class MlPredictionService {
  const MlPredictionService();

  DifficultyPrediction buildPrediction(PlayerCognitiveProfile profile) {
    final confidence = _confidenceFromSamples(profile.totalSessions);
    final normalizedTime = _normalizeTime(profile.averageTimePerLink);
    final themes = profile.strongDomains.isNotEmpty
        ? profile.strongDomains.take(3).toList()
        : <String>['General Knowledge'];
    final focusAreas = profile.focusAreas.isNotEmpty
        ? profile.focusAreas
        : (profile.strongDomains.isNotEmpty
            ? [profile.strongDomains.first]
            : <String>['Exploration']);

    final headline = profile.recommendedLinks >= 6
        ? 'Ready for deeper ${profile.recommendedLinks}-link chains'
        : 'Build confidence with ${profile.recommendedLinks}-link chains';

    final rationale =
        'Win rate ${(profile.winRate * 100).toStringAsFixed(0)}% • Avg ${profile.averageTimePerLink.toStringAsFixed(1)}s/link';

    return DifficultyPrediction(
      recommendedLinks: profile.recommendedLinks,
      confidence: confidence,
      suggestedTimePerStep: Duration(seconds: normalizedTime),
      recommendedThemes: themes,
      focusAreas: focusAreas,
      headline: headline,
      rationale: rationale,
    );
  }

  LearningPath buildLearningPath(PlayerCognitiveProfile profile) {
    final targets = <LearningTarget>[];
    final focusDomains = profile.focusAreas.isNotEmpty
        ? profile.focusAreas
        : (profile.strongDomains.isNotEmpty
            ? profile.strongDomains
            : <String>['General Knowledge']);

    for (var index = 0; index < focusDomains.length && index < 3; index++) {
      final domain = focusDomains[index];
      final offset =
          index == 0 ? 0 : (index == 1 ? 1 : -1); // mix of stretch vs reinforce
      final links = (profile.recommendedLinks + offset)
          .clamp(GameConstants.minLinks, GameConstants.maxLinks);
      final focus = index == 0 ? 'Focus' : (offset > 0 ? 'Stretch' : 'Refine');
      final action = offset > 0
          ? 'Attempt $links-link puzzles in $domain'
          : 'Replay $links-link puzzles for fluency';
      targets.add(
        LearningTarget(
          category: domain,
          linksCount: links,
          focus: '$focus your reasoning in $domain',
          nextAction: action,
        ),
      );
    }

    if (targets.isEmpty) {
      targets.add(
        LearningTarget(
          category: 'General Knowledge',
          linksCount: profile.recommendedLinks,
          focus: 'Explore diverse themes',
          nextAction: 'Play two puzzles outside your comfort zone',
        ),
      );
    }

    return LearningPath(
      generatedAt: DateTime.now(),
      targets: targets,
    );
  }

  double _confidenceFromSamples(int totalSessions) {
    if (totalSessions <= 0) return 0.25;
    return (totalSessions / 25).clamp(0.1, 0.95);
  }

  int _normalizeTime(double avgTimePerLink) {
    if (avgTimePerLink <= 0) {
      return GameConstants.timePerStep;
    }
    return avgTimePerLink
        .clamp(GameConstants.minTimePerStep.toDouble(),
            GameConstants.maxTimePerStep.toDouble())
        .round();
  }
}
