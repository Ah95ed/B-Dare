import 'package:equatable/equatable.dart';
import '../../domain/entities/puzzle.dart';
import '../../domain/entities/link_node.dart';
import '../../domain/entities/game_type.dart';
import '../../../progression/domain/entities/progression_summary.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {
  const GameInitial();
}

class GameLoading extends GameState {
  const GameLoading();
}

class GameInProgress extends GameState {
  final Puzzle puzzle;
  final GameType gameType;
  final int currentStep;
  final List<LinkNode> chosenNodes;
  final int score;
  final int remainingSeconds;
  final bool isTimeOut;
  final DateTime? startTime;
  final String? notice;
  final Map<String, dynamic>? gameSpecificData; // بيانات خاصة بكل نمط

  const GameInProgress({
    required this.puzzle,
    this.gameType = GameType.mysteryLink,
    required this.currentStep,
    required this.chosenNodes,
    required this.score,
    required this.remainingSeconds,
    this.isTimeOut = false,
    this.startTime,
    this.notice,
    this.gameSpecificData,
  });

  GameInProgress copyWith({
    Puzzle? puzzle,
    GameType? gameType,
    int? currentStep,
    List<LinkNode>? chosenNodes,
    int? score,
    int? remainingSeconds,
    bool? isTimeOut,
    DateTime? startTime,
    String? notice,
    Map<String, dynamic>? gameSpecificData,
  }) {
    return GameInProgress(
      puzzle: puzzle ?? this.puzzle,
      gameType: gameType ?? this.gameType,
      currentStep: currentStep ?? this.currentStep,
      chosenNodes: chosenNodes ?? this.chosenNodes,
      score: score ?? this.score,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isTimeOut: isTimeOut ?? this.isTimeOut,
      startTime: startTime ?? this.startTime,
      notice: notice ?? this.notice,
      gameSpecificData: gameSpecificData ?? this.gameSpecificData,
    );
  }

  bool get isCompleted {
    if (gameType == GameType.mysteryLink) {
      return currentStep > puzzle.linksCount;
    }
    // للأنماط الأخرى، يتم التحقق من gameSpecificData
    return gameSpecificData?['isCompleted'] == true;
  }

  @override
  List<Object?> get props => [
        puzzle,
        gameType,
        currentStep,
        chosenNodes,
        score,
        remainingSeconds,
        isTimeOut,
        startTime,
        notice,
        gameSpecificData,
      ];
}

class GameCompleted extends GameState {
  final Puzzle puzzle;
  final List<LinkNode> chosenNodes;
  final int score;
  final Duration timeSpent;
  final bool isPerfect;
  final ProgressionSummary? progression;

  const GameCompleted({
    required this.puzzle,
    required this.chosenNodes,
    required this.score,
    required this.timeSpent,
    this.isPerfect = false,
    this.progression,
  });

  @override
  List<Object?> get props => [
        puzzle,
        chosenNodes,
        score,
        timeSpent,
        isPerfect,
        progression,
      ];
}

class GameTimeOutState extends GameState {
  final Puzzle puzzle;
  final List<LinkNode> chosenNodes;
  final int score;
  final ProgressionSummary? progression;

  const GameTimeOutState({
    required this.puzzle,
    required this.chosenNodes,
    required this.score,
    this.progression,
  });

  @override
  List<Object?> get props => [puzzle, chosenNodes, score, progression];
}

class GameErrorState extends GameState {
  final String message;

  const GameErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

