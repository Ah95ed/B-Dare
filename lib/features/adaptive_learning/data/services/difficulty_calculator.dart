import '../../../../core/constants/game_constants.dart';

class DifficultyCalculator {
  const DifficultyCalculator();

  int recommend({
    required int lastLinks,
    required double winRate,
    required double perfectRate,
    required double averageTimePerLink,
    required int previousRecommendation,
  }) {
    var recommendation = previousRecommendation;

    if (recommendation == 0) {
      recommendation = lastLinks;
    }

    if (winRate >= 0.8 && averageTimePerLink <= 9) {
      recommendation += 2;
    } else if (winRate >= 0.65 && perfectRate >= 0.3) {
      recommendation += 1;
    } else if (winRate < 0.45 || averageTimePerLink > 18) {
      recommendation -= 1;
    }

    if (perfectRate < 0.15 && winRate < 0.55) {
      recommendation -= 1;
    }

    recommendation = recommendation.clamp(
      GameConstants.minLinks,
      GameConstants.maxLinks,
    );
    return recommendation;
  }
}
