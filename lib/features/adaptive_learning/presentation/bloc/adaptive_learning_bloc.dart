import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/difficulty_prediction.dart';
import '../../domain/entities/learning_path.dart';
import '../../domain/entities/player_cognitive_profile.dart';
import '../../domain/repositories/adaptive_learning_repository_interface.dart';

part 'adaptive_learning_event.dart';
part 'adaptive_learning_state.dart';

class AdaptiveLearningBloc
    extends Bloc<AdaptiveLearningEvent, AdaptiveLearningState> {
  final AdaptiveLearningRepositoryInterface repository;

  AdaptiveLearningBloc({required this.repository})
      : super(const AdaptiveLearningState()) {
    on<AdaptiveLearningProfileRequested>(_onRequested);
    on<AdaptiveLearningRefreshRequested>(_onRequested);
  }

  Future<void> _onRequested(
    AdaptiveLearningEvent event,
    Emitter<AdaptiveLearningState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AdaptiveLearningStatus.loading, error: null));
      final profile = await repository.getProfile();
      final prediction = await repository.getPrediction();
      final path = await repository.getLearningPath();
      emit(
        state.copyWith(
          status: AdaptiveLearningStatus.ready,
          profile: profile,
          prediction: prediction,
          learningPath: path,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AdaptiveLearningStatus.error,
          error: error.toString(),
        ),
      );
    }
  }
}
