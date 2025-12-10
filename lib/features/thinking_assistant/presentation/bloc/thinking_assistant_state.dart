part of 'thinking_assistant_bloc.dart';

enum ThinkingAssistantStatus { idle, loading, ready, error }

class ThinkingAssistantState extends Equatable {
  final ThinkingAssistantStatus status;
  final HintLevel level;
  final ThinkingInsight? insight;
  final String? error;

  const ThinkingAssistantState({
    this.status = ThinkingAssistantStatus.idle,
    this.level = HintLevel.gentle,
    this.insight,
    this.error,
  });

  ThinkingAssistantState copyWith({
    ThinkingAssistantStatus? status,
    HintLevel? level,
    ThinkingInsight? insight,
    String? error,
  }) {
    return ThinkingAssistantState(
      status: status ?? this.status,
      level: level ?? this.level,
      insight: insight ?? this.insight,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, level, insight, error];
}
