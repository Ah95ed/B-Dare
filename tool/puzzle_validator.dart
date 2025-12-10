import 'dart:convert';
import 'dart:io';

import 'package:mystery_link/core/constants/game_constants.dart';

const puzzlesPath = 'assets/data/puzzles.json';
const requirementsPath = 'tool/puzzle_requirements.json';
const requiredRepresentations = [
  'text',
  'icon',
  'image',
  'event',
];

Future<void> main(List<String> args) async {
  final file = File(puzzlesPath);
  if (!await file.exists()) {
    stderr.writeln('Missing $puzzlesPath. Run from project root.');
    exit(1);
  }

  final jsonList = json.decode(await file.readAsString());
  if (jsonList is! List) {
    stderr.writeln('Invalid puzzles file format.');
    exit(1);
  }

  final requirements = await _loadRequirements();
  final summary = _PuzzleSummary();
  for (final entry in jsonList) {
    if (entry is! Map<String, dynamic>) {
      summary.invalidEntries++;
      continue;
    }
    summary.totalPuzzles++;
    final category =
        (entry['category'] as String?)?.trim().toLowerCase() ?? 'uncategorized';
    final rep = (entry['type'] as String?)?.trim().toLowerCase() ?? 'text';
    summary.categories.putIfAbsent(category, () => _CategorySummary());
    final catSummary = summary.categories[category]!;
    catSummary.count++;
    catSummary.representationsCount[rep] =
        (catSummary.representationsCount[rep] ?? 0) + 1;
    summary.representationTotals[rep] =
        (summary.representationTotals[rep] ?? 0) + 1;

    if ((entry['type'] as String?) == 'image') {
      final start = entry['start'] as Map<String, dynamic>?;
      final end = entry['end'] as Map<String, dynamic>?;
      final imagePaths = [
        start?['imagePath'],
        end?['imagePath'],
        entry['imagePath'],
      ];
      final hasImage = imagePaths.any(
        (path) => path is String && path.trim().isNotEmpty,
      );
      if (!hasImage) {
        summary.missingAssets.add(entry['id']?.toString() ?? '<unknown>');
      }
    }
  }

  final violations = _evaluateRequirements(summary, requirements);
  _printReport(summary, violations);
  if (violations.isNotEmpty) {
    stderr.writeln('\n❌ Puzzle coverage requirements failed.');
    exit(1);
  }
}

Future<_Requirements> _loadRequirements() async {
  final file = File(requirementsPath);
  if (await file.exists()) {
    try {
      final jsonMap = json.decode(await file.readAsString()) as Map<String, dynamic>;
      return _Requirements.fromJson(jsonMap);
    } catch (e) {
      stderr.writeln('Failed to parse $requirementsPath: $e');
    }
  }
  return _Requirements.defaults();
}

List<String> _evaluateRequirements(
  _PuzzleSummary summary,
  _Requirements requirements,
) {
  final issues = <String>[];

  for (final entry in requirements.categories.entries) {
    final name = entry.key;
    final req = entry.value;
    final normalized = name.toLowerCase();
    final catSummary = summary.categories[normalized];
    if (catSummary == null || catSummary.count == 0) {
      issues.add('Category "$name" has no puzzles.');
      continue;
    }
    if (catSummary.count < req.minTotal) {
      issues.add(
        'Category "$name" has ${catSummary.count}/${req.minTotal} required puzzles.',
      );
    }
    for (final rep in req.representationsRequired) {
      final repCount = catSummary.representationsCount[rep] ?? 0;
      if (repCount < req.minPerRepresentation) {
        issues.add(
          'Category "$name" needs ${req.minPerRepresentation} "$rep" puzzles (current: $repCount).',
        );
      }
    }
  }

  for (final rep in requiredRepresentations) {
    final total = summary.representationTotals[rep] ?? 0;
    if (total < requirements.globalMinPerRepresentation) {
      issues.add(
        'Global requirement: at least ${requirements.globalMinPerRepresentation} "$rep" puzzles (current: $total).',
      );
    }
  }

  return issues;
}

void _printReport(_PuzzleSummary summary, List<String> violations) {
  stdout.writeln('Puzzle Coverage Report');
  stdout.writeln('======================');
  stdout.writeln('Total puzzles: ${summary.totalPuzzles}');
  stdout.writeln('Invalid entries: ${summary.invalidEntries}');

  for (final category in summary.categories.entries) {
    stdout.writeln('\nCategory: ${category.key}');
    stdout.writeln('  Count: ${category.value.count}');
    for (final representation in requiredRepresentations) {
      final count = category.value.representationsCount[representation] ?? 0;
      final hasRepresentation = count > 0;
      stdout.writeln(
        '  - ${representation.padRight(5)}: ${hasRepresentation ? '✔' : '✘'} ($count)',
      );
    }
  }

  if (summary.missingAssets.isNotEmpty) {
    stdout.writeln('\nPuzzles missing image assets:');
    for (final id in summary.missingAssets) {
      stdout.writeln('  - $id');
    }
  }
  if (violations.isNotEmpty) {
    stdout.writeln('\nRequirement Violations:');
    for (final issue in violations) {
      stdout.writeln('  - $issue');
    }
  } else {
    stdout.writeln('\n✅ All category requirements satisfied.');
  }
}

class _PuzzleSummary {
  int totalPuzzles = 0;
  int invalidEntries = 0;
  final Map<String, _CategorySummary> categories = {};
  final Set<String> missingAssets = {};
  final Map<String, int> representationTotals = {};
}

class _CategorySummary {
  int count = 0;
  final Map<String, int> representationsCount = {};
}

class _Requirements {
  final Map<String, _CategoryRequirement> categories;
  final int globalMinPerRepresentation;

  _Requirements({
    required this.categories,
    required this.globalMinPerRepresentation,
  });

  factory _Requirements.defaults() {
    final map = {
      for (final category in GameConstants.linkCategories
          .where((c) => c != GameConstants.linkCategoryAny))
        category.toLowerCase(): _CategoryRequirement(
          name: category,
          minTotal: 5,
          minPerRepresentation: 1,
          representationsRequired: requiredRepresentations,
        ),
    };
    return _Requirements(
      categories: map,
      globalMinPerRepresentation: 10,
    );
  }

  factory _Requirements.fromJson(Map<String, dynamic> json) {
    final categoriesJson = json['categories'] as List<dynamic>? ?? const [];
    final categories = <String, _CategoryRequirement>{};
    for (final entry in categoriesJson) {
      if (entry is! Map<String, dynamic>) continue;
      final requirement = _CategoryRequirement.fromJson(entry);
      categories[requirement.name.toLowerCase()] = requirement;
    }
    final minPerRep = json['globalMinPerRepresentation'] as int? ?? 10;
    return _Requirements(
      categories: categories.isEmpty
          ? _Requirements.defaults().categories
          : categories,
      globalMinPerRepresentation: minPerRep,
    );
  }
}

class _CategoryRequirement {
  final String name;
  final int minTotal;
  final int minPerRepresentation;
  final List<String> representationsRequired;

  _CategoryRequirement({
    required this.name,
    required this.minTotal,
    required this.minPerRepresentation,
    required this.representationsRequired,
  });

  factory _CategoryRequirement.fromJson(Map<String, dynamic> json) {
    final reps = (json['requiredRepresentations'] as List<dynamic>?)
            ?.map((e) => e.toString().toLowerCase())
            .toList() ??
        requiredRepresentations;
    return _CategoryRequirement(
      name: json['name'] as String? ?? 'Uncategorized',
      minTotal: json['minTotal'] as int? ?? 5,
      minPerRepresentation: json['minPerRepresentation'] as int? ?? 1,
      representationsRequired: reps,
    );
  }
}
