import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late File puzzlesFile;
  late String rawContent;
  late List<dynamic> puzzles;

  setUpAll(() {
    puzzlesFile = File('assets/data/puzzles.json');
    if (!puzzlesFile.existsSync()) {
      fail('Missing puzzles asset at ${puzzlesFile.path}');
    }
    rawContent = puzzlesFile.readAsStringSync();
    try {
      puzzles = json.decode(rawContent) as List<dynamic>;
    } on FormatException catch (e) {
      fail('Unable to decode puzzles.json: $e');
    }
  });

  test('asset exists and contains puzzle list', () {
    expect(rawContent.trim(), isNotEmpty,
        reason: 'puzzles.json should not be empty');
    expect(puzzles, isNotEmpty, reason: 'No puzzles found in puzzles.json');
  });

  test('each puzzle entry has consistent structure', () {
    for (final puzzle in puzzles) {
      final map = puzzle as Map<String, dynamic>;
      expect(
        (map['id'] as String).trim().isNotEmpty,
        isTrue,
        reason: 'Puzzle id must be provided',
      );
      expect(map['start'], isA<Map<String, dynamic>>());
      expect(map['end'], isA<Map<String, dynamic>>());
      final steps = map['steps'] as List<dynamic>;
      expect(steps, isNotEmpty, reason: 'Puzzle ${map['id']} has no steps');
      expect(
        steps.length,
        equals(map['linksCount']),
        reason:
            'Puzzle ${map['id']} linksCount must match number of steps (${steps.length})',
      );
      for (final step in steps) {
        final stepMap = step as Map<String, dynamic>;
        final options = stepMap['options'] as List<dynamic>;
        expect(
          options,
          isNotEmpty,
          reason:
              'Puzzle ${map['id']} step ${stepMap['order']} must have options',
        );
        final correctCount =
            options.where((opt) => opt['isCorrect'] == true).length;
        expect(
          correctCount,
          equals(1),
          reason:
              'Puzzle ${map['id']} step ${stepMap['order']} must have one correct option',
        );
      }
    }
  });

  test('all four representation types are present', () {
    final seen = <String>{};
    for (final puzzle in puzzles) {
      final value = (puzzle as Map<String, dynamic>)['type']?.toString();
      if (value != null) {
        seen.add(value.toLowerCase());
      }
    }
    expect(
      seen.containsAll({'text', 'icon', 'image', 'event'}),
      isTrue,
      reason:
          'puzzles.json should provide coverage for text, icon, image, and event representations',
    );
  });
}

