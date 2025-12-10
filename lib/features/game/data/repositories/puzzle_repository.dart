import 'dart:math';
import '../../domain/entities/puzzle.dart';
import '../../domain/entities/link_node.dart';
import '../../domain/entities/game_type.dart';
import '../../domain/repositories/puzzle_repository_interface.dart';
import '../datasources/local_puzzle_datasource.dart';
import '../models/puzzle_model.dart';

class PuzzleRepository implements PuzzleRepositoryInterface {
  final LocalPuzzleDatasource _datasource;
  List<PuzzleModel>? _cachedPuzzles;

  PuzzleRepository(this._datasource);

  Future<List<PuzzleModel>> _getAllPuzzlesModel() async {
    _cachedPuzzles ??= await _datasource.loadPuzzles();
    return _cachedPuzzles!;
  }

  @override
  Future<List<Puzzle>> getAllPuzzles() async {
    return await _getAllPuzzlesModel();
  }

  @override
  Future<Puzzle?> getPuzzleById(String id) async {
    final puzzles = await _getAllPuzzlesModel();
    try {
      return puzzles.firstWhere((puzzle) => puzzle.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Puzzle?> getRandomPuzzle({
    RepresentationType? type,
    int? linksCount,
    String? difficulty,
    String? category,
  }) async {
    final puzzles = await _getAllPuzzlesModel();
    var filtered = puzzles;

    if (type != null) {
      filtered = filtered.where((p) => p.type == type).toList();
    }

    if (difficulty != null && difficulty.trim().isNotEmpty) {
      final normalized = difficulty.trim().toLowerCase();
      filtered = filtered
          .where((p) => (p.difficulty ?? '').toLowerCase() == normalized)
          .toList();
    }

    if (category != null && category.trim().isNotEmpty) {
      final normalized = category.trim().toLowerCase();
      filtered = filtered
          .where((p) => (p.category ?? '').toLowerCase() == normalized)
          .toList();
    }

    if (filtered.isEmpty) {
      return null;
    }

    if (linksCount != null) {
      final linkMatches =
          filtered.where((p) => p.linksCount == linksCount).toList();
      if (linkMatches.isNotEmpty) {
        filtered = linkMatches;
      }
    }

    if (filtered.isEmpty) {
      return null;
    }

    final random = Random();
    return filtered[random.nextInt(filtered.length)];
  }

  @override
  Future<List<Puzzle>> getPuzzlesByDifficulty(int linksCount) async {
    final puzzles = await _getAllPuzzlesModel();
    return puzzles.where((p) => p.linksCount == linksCount).toList();
  }

  @override
  Future<List<Puzzle>> getPuzzlesByType(RepresentationType type) async {
    final puzzles = await _getAllPuzzlesModel();
    return puzzles.where((p) => p.type == type).toList();
  }

  @override
  Future<List<Puzzle>> getPuzzlesForLevel(
    GameType mode,
    int level, {
    bool sortByChallenge = true,
  }) async {
    final puzzles = await _getAllPuzzlesModel();
    final filtered = puzzles
        .where(
          (p) => p.gameType == mode && (p.level ?? -1) == level,
        )
        .toList();

    if (sortByChallenge) {
      filtered.sort(
        (a, b) => (a.challengeNumber ?? 0).compareTo(b.challengeNumber ?? 0),
      );
    }

    return filtered;
  }

  @override
  Future<Puzzle?> getPuzzleForChallenge(
    GameType mode,
    int level,
    int challengeNumber,
  ) async {
    final puzzles = await _getAllPuzzlesModel();
    try {
      return puzzles.firstWhere(
        (p) =>
            p.gameType == mode &&
            (p.level ?? -1) == level &&
            (p.challengeNumber ?? -1) == challengeNumber,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Map<int, List<Puzzle>>> getLevelsForMode(
    GameType mode, {
    int? maxLevels,
  }) async {
    final puzzles = await _getAllPuzzlesModel();
    final grouped = <int, List<Puzzle>>{};

    for (final puzzle in puzzles.where((p) => p.gameType == mode)) {
      final level = puzzle.level;
      if (level == null) continue;
      if (maxLevels != null && level > maxLevels) continue;
      grouped.putIfAbsent(level, () => []).add(puzzle);
    }

    if (grouped.isEmpty) return {};

    for (final entry in grouped.entries) {
      entry.value.sort(
        (a, b) => (a.challengeNumber ?? 0).compareTo(b.challengeNumber ?? 0),
      );
    }

    return Map<int, List<Puzzle>>.fromEntries(
      grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }
}
