import 'package:equatable/equatable.dart';
import '../../domain/entities/link_node.dart';
import '../../domain/entities/puzzle.dart';
import '../../domain/entities/game_type.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class GameStarted extends GameEvent {
  final GameType gameType;
  final RepresentationType representationType;
  final int linksCount;
  final String gameMode;
  final int? playersCount;
  final String? category;
  final String? groupProfile;
  final List<Map<String, dynamic>>? customPlayers;
  final Map<String, dynamic>? customPuzzle;

  const GameStarted({
    this.gameType = GameType.mysteryLink,
    required this.representationType,
    required this.linksCount,
    required this.gameMode,
    this.playersCount,
    this.category,
    this.groupProfile,
    this.customPlayers,
    this.customPuzzle,
  });

  @override
  List<Object?> get props => [
        gameType,
        representationType,
        linksCount,
        gameMode,
        playersCount,
        category,
        groupProfile,
        customPlayers,
        customPuzzle,
      ];
}

class PuzzleLoaded extends GameEvent {
  final Puzzle? puzzle;
  final String? notice;

  const PuzzleLoaded(this.puzzle, {this.notice});

  @override
  List<Object?> get props => [puzzle, notice];
}

class StepOptionSelected extends GameEvent {
  final int stepOrder;
  final LinkNode selectedNode;
  final Map<String, dynamic>? gameSpecificData; // بيانات خاصة بالنمط

  const StepOptionSelected({
    required this.stepOrder,
    required this.selectedNode,
    this.gameSpecificData,
  });

  @override
  List<Object?> get props => [stepOrder, selectedNode, gameSpecificData];
}

// Events جديدة للأنماط المختلفة
class CardFlipped extends GameEvent {
  final String cardId;
  final Map<String, dynamic>? gameSpecificData;

  const CardFlipped({
    required this.cardId,
    this.gameSpecificData,
  });

  @override
  List<Object?> get props => [cardId, gameSpecificData];
}

class ItemSelected extends GameEvent {
  final String itemId;
  final Map<String, dynamic>? gameSpecificData;

  const ItemSelected({
    required this.itemId,
    this.gameSpecificData,
  });

  @override
  List<Object?> get props => [itemId, gameSpecificData];
}

class ItemMoved extends GameEvent {
  final String itemId;
  final int newPosition;
  final Map<String, dynamic>? gameSpecificData;

  const ItemMoved({
    required this.itemId,
    required this.newPosition,
    this.gameSpecificData,
  });

  @override
  List<Object?> get props => [itemId, newPosition, gameSpecificData];
}

class TileArranged extends GameEvent {
  final String tileId;
  final int newPosition;
  final Map<String, dynamic>? gameSpecificData;

  const TileArranged({
    required this.tileId,
    required this.newPosition,
    this.gameSpecificData,
  });

  @override
  List<Object?> get props => [tileId, newPosition, gameSpecificData];
}

class TimerTicked extends GameEvent {
  final int remainingSeconds;

  const TimerTicked(this.remainingSeconds);

  @override
  List<Object?> get props => [remainingSeconds];
}

class GameTimeOut extends GameEvent {
  const GameTimeOut();
}

class GameFinished extends GameEvent {
  const GameFinished();
}

class GameReset extends GameEvent {
  const GameReset();
}

class GameError extends GameEvent {
  final String message;

  const GameError(this.message);

  @override
  List<Object?> get props => [message];
}

class HintUsed extends GameEvent {
  final int stepOrder;

  const HintUsed({required this.stepOrder});

  @override
  List<Object?> get props => [stepOrder];
}

