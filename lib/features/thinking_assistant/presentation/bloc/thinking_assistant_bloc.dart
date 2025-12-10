import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../game/domain/entities/link_node.dart';
import '../../../game/domain/entities/puzzle.dart';
import '../../../game/domain/entities/puzzle_step.dart';
import '../../domain/entities/hint_level.dart';
import '../../domain/entities/thinking_insight.dart';
import '../../domain/services/hint_generator_service.dart';

part 'thinking_assistant_event.dart';
part 'thinking_assistant_state.dart';

class ThinkingAssistantBloc
    extends Bloc<ThinkingAssistantEvent, ThinkingAssistantState> {
  final HintGeneratorService service;

  ThinkingAssistantBloc({required this.service})
      : super(const ThinkingAssistantState()) {
    on<ThinkingAssistantHintRequested>(_onHintRequested);
    on<ThinkingAssistantLevelChanged>(_onLevelChange);
    on<ThinkingAssistantReset>(_onReset);
  }

  Future<void> _onHintRequested(
    ThinkingAssistantHintRequested event,
    Emitter<ThinkingAssistantState> emit,
  ) async {
    emit(state.copyWith(status: ThinkingAssistantStatus.loading, error: null));
    try {
      final insight = await service.generate(
        puzzle: event.puzzle,
        step: event.step,
        chosenNodes: event.chosenNodes,
        level: state.level,
      );
      emit(
        state.copyWith(
          status: ThinkingAssistantStatus.ready,
          insight: insight,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ThinkingAssistantStatus.error,
          error: error.toString(),
        ),
      );
    }
  }

  void _onLevelChange(
    ThinkingAssistantLevelChanged event,
    Emitter<ThinkingAssistantState> emit,
  ) {
    emit(state.copyWith(level: event.level));
  }

  void _onReset(
    ThinkingAssistantReset event,
    Emitter<ThinkingAssistantState> emit,
  ) {
    emit(const ThinkingAssistantState());
  }
}
