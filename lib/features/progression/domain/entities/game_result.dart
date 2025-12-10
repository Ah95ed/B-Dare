import '../../../game/domain/entities/puzzle.dart';

class GameResult {
  final Puzzle puzzle;
  final int score;
  final Duration timeSpent;
  final bool isPerfect;
  final bool isDaily;
  final bool isWin;
  final DateTime completedAt;

  const GameResult({
    required this.puzzle,
    required this.score,
    required this.timeSpent,
    required this.isPerfect,
    required this.isDaily,
    required this.isWin,
    required this.completedAt,
  });
}
