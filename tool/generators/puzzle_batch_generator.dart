import 'dart:convert';
import 'dart:io';

/// Script to bootstrap 30 levels x 10 challenges per game mode.
/// Run with `dart run tool/generators/puzzle_batch_generator.dart --output build/generated_puzzles.json`
Future<void> main(List<String> args) async {
  final outputIndex = args.indexWhere((arg) => arg == '--output');
  final outputPath = outputIndex != -1 && outputIndex + 1 < args.length
      ? args[outputIndex + 1]
      : 'build/generated_puzzles.json';

  const modes = <String, Map<String, dynamic>>{
    'mysteryLink': {
      'representation': 'text',
      'baseCategory': 'Mystery Link',
    },
    'memoryFlip': {
      'representation': 'icon',
      'baseCategory': 'Memory',
    },
    'spotTheOdd': {
      'representation': 'image',
      'baseCategory': 'Spot the Odd',
    },
    'shadowMatch': {
      'representation': 'image',
      'baseCategory': 'Shadow Match',
    },
    'sortSolve': {
      'representation': 'text',
      'baseCategory': 'Sorting',
    },
    'storyTiles': {
      'representation': 'text',
      'baseCategory': 'Story Tiles',
    },
    'puzzleSentence': {
      'representation': 'text',
      'baseCategory': 'Sentence Lab',
    },
    'emojiCircuit': {
      'representation': 'icon',
      'baseCategory': 'Emoji Circuit',
    },
    'cipherTiles': {
      'representation': 'text',
      'baseCategory': 'Cipher Tiles',
    },
    'colorHarmony': {
      'representation': 'image',
      'baseCategory': 'Color Harmony',
    },
    'spotTheChange': {
      'representation': 'image',
      'baseCategory': 'Spot the Change',
    },
  };

  final puzzles = <Map<String, dynamic>>[];
  for (final entry in modes.entries) {
    final mode = entry.key;
    final config = entry.value;
    for (var level = 1; level <= 30; level++) {
      for (var challenge = 1; challenge <= 10; challenge++) {
        final id = '${mode}_L${level}_C$challenge';
        final timeLimit = 60 + (level * 2);
        final steps =
            _buildSteps(level, challenge, config['representation'] as String);
        final puzzle = {
          'id': id,
          'gameType': mode,
          'type': config['representation'],
          'category': config['baseCategory'],
          'difficulty': _difficultyForLevel(level),
          'level': level,
          'challengeNumber': challenge,
          'targetSkill': _skillForMode(mode),
          'theme': _themeForLevel(level),
          'tags': [_skillForMode(mode), 'level-$level', 'challenge-$challenge'],
          'progressionData': {
            'rewardXp': 20 + level,
            'season': 'founders',
            'recommendedPlayers': mode == 'mysteryLink' ? 1 : 2,
          },
          'linksCount': steps.length,
          'timeLimit': timeLimit,
          'start': _buildNode('start', mode, level, challenge),
          'end': _buildNode('end', mode, level, challenge),
          'steps': steps,
          'gameTypeData': {
            'aiHint': 'Connect ${_skillForMode(mode)} ${level * challenge}',
          },
        };
        puzzles.add(puzzle);
      }
    }
  }

  final outFile = File(outputPath);
  await outFile.create(recursive: true);
  await outFile
      .writeAsString(const JsonEncoder.withIndent('  ').convert(puzzles));
  stdout.writeln('Generated ${puzzles.length} puzzles at $outputPath');
}

List<Map<String, dynamic>> _buildSteps(
    int level, int challenge, String representation) {
  final steps = <Map<String, dynamic>>[];
  const optionsPerStep = 3;
  for (var order = 1; order <= 3; order++) {
    final options = <Map<String, dynamic>>[];
    for (var i = 0; i < optionsPerStep; i++) {
      final optionId = 'opt_${level}_${challenge}_${order}_$i';
      options.add({
        'node':
            _buildNode(optionId, representation, level, challenge, suffix: i),
        'isCorrect': i == 0,
      });
    }
    steps.add({
      'order': order,
      'timeLimit': 10 + level,
      'options': options,
    });
  }
  return steps;
}

Map<String, dynamic> _buildNode(
  String id,
  dynamic context,
  int level,
  int challenge, {
  int suffix = 0,
}) {
  return {
    'id': '$id-$suffix',
    'label': '$context-$level-$challenge-$suffix',
    'representationType': 'text',
    'labels': {
      'en': '$context-$level-$challenge-$suffix',
      'ar': '$context-$level-$challenge-$suffix',
    },
  };
}

String _difficultyForLevel(int level) {
  if (level <= 10) return 'easy';
  if (level <= 20) return 'medium';
  return 'hard';
}

String _skillForMode(String mode) {
  switch (mode) {
    case 'memoryFlip':
      return 'memory';
    case 'spotTheOdd':
      return 'attention';
    case 'spotTheChange':
      return 'visual-diff';
    case 'cipherTiles':
      return 'decoding';
    case 'colorHarmony':
      return 'color-theory';
    case 'emojiCircuit':
      return 'logic';
    case 'storyTiles':
      return 'storytelling';
    default:
      return 'association';
  }
}

String _themeForLevel(int level) {
  if (level <= 10) return 'Foundations';
  if (level <= 20) return 'Momentum';
  return 'Mastery';
}
