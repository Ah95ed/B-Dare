import '../../../progression/domain/entities/game_result.dart';
import '../entities/difficulty_prediction.dart';
import '../entities/learning_path.dart';
import '../entities/player_cognitive_profile.dart';

abstract class AdaptiveLearningRepositoryInterface {
  Future<PlayerCognitiveProfile> getProfile();
  Future<PlayerCognitiveProfile> recordResult(GameResult result);
  Future<DifficultyPrediction> getPrediction();
  Future<LearningPath> getLearningPath();
}
