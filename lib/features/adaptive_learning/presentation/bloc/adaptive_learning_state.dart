part of 'adaptive_learning_bloc.dart';

enum AdaptiveLearningStatus { initial, loading, ready, error }

class AdaptiveLearningState extends Equatable {
  final AdaptiveLearningStatus status;
  final PlayerCognitiveProfile? profile;
  final DifficultyPrediction? prediction;
  final LearningPath? learningPath;
  final String? error;

  const AdaptiveLearningState({
    this.status = AdaptiveLearningStatus.initial,
    this.profile,
    this.prediction,
    this.learningPath,
    this.error,
  });

  AdaptiveLearningState copyWith({
    AdaptiveLearningStatus? status,
    PlayerCognitiveProfile? profile,
    DifficultyPrediction? prediction,
    LearningPath? learningPath,
    String? error,
  }) {
    return AdaptiveLearningState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      prediction: prediction ?? this.prediction,
      learningPath: learningPath ?? this.learningPath,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, profile, prediction, learningPath, error];
}
