import '../entities/puzzle.dart';
import '../entities/link_node.dart';
import '../entities/game_type.dart';

abstract class PuzzleRepositoryInterface {
  Future<List<Puzzle>> getAllPuzzles();
  Future<Puzzle?> getPuzzleById(String id);
  Future<Puzzle?> getRandomPuzzle({
    RepresentationType? type,
    int? linksCount,
    String? difficulty,
    String? category,
  });
  Future<List<Puzzle>> getPuzzlesByDifficulty(int linksCount);
  Future<List<Puzzle>> getPuzzlesByType(RepresentationType type);
  Future<List<Puzzle>> getPuzzlesForLevel(
    GameType mode,
    int level, {
    bool sortByChallenge = true,
  });
  Future<Puzzle?> getPuzzleForChallenge(
    GameType mode,
    int level,
    int challengeNumber,
  );
  Future<Map<int, List<Puzzle>>> getLevelsForMode(
    GameType mode, {
    int? maxLevels,
  });
}
