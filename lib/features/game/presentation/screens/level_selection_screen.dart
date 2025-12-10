import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../game/data/repositories/puzzle_repository.dart';
import '../../../game/domain/entities/puzzle.dart';
import '../../../game/domain/entities/game_type.dart';

class LevelSelectionScreen extends StatefulWidget {
  final GameType gameType;
  final String modeTitle;

  const LevelSelectionScreen({
    super.key,
    required this.gameType,
    required this.modeTitle,
  });

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  Future<Map<int, List<Puzzle>>>? _levelsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _levelsFuture ??= context
        .read<PuzzleRepository>()
        .getLevelsForMode(widget.gameType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Levels · ${widget.modeTitle}'),
      ),
      body: FutureBuilder<Map<int, List<Puzzle>>>(
        future: _levelsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Unable to load levels: ${snapshot.error}'),
            );
          }
          final levels = snapshot.data;
          if (levels == null || levels.isEmpty) {
            return const Center(
              child: Text('No structured levels were found.'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: levels.entries.map((entry) {
              final level = entry.key;
              final puzzles = entry.value;
              return _LevelCard(
                level: level,
                puzzles: puzzles,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final int level;
  final List<Puzzle> puzzles;

  const _LevelCard({
    required this.level,
    required this.puzzles,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text('Level $level'),
        subtitle: Text(
          'Challenges ${puzzles.length}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: puzzles
            .map(
              (puzzle) => ListTile(
                leading: CircleAvatar(
                  child: Text(
                    (puzzle.challengeNumber ?? 0).toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(puzzle.targetSkill ?? puzzle.category ?? 'Challenge'),
                subtitle: Text(
                  'Difficulty: ${puzzle.difficulty ?? 'n/a'} · ${puzzle.theme ?? 'Theme TBD'}',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context, {
                    'level': level,
                    'challengeNumber': puzzle.challengeNumber,
                    'puzzleId': puzzle.id,
                  });
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
