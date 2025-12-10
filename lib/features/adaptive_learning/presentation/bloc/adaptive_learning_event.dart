part of 'adaptive_learning_bloc.dart';

abstract class AdaptiveLearningEvent extends Equatable {
  const AdaptiveLearningEvent();

  @override
  List<Object?> get props => [];
}

class AdaptiveLearningProfileRequested extends AdaptiveLearningEvent {
  const AdaptiveLearningProfileRequested();
}

class AdaptiveLearningRefreshRequested extends AdaptiveLearningEvent {
  const AdaptiveLearningRefreshRequested();
}
