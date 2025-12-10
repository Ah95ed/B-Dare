import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/puzzle_model.dart';
import 'puzzle_data_exception.dart';

class LocalPuzzleDatasource {
  static const String _puzzlesPath = 'assets/data/puzzles.json';
  final AssetBundle _bundle;

  LocalPuzzleDatasource({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  Future<List<PuzzleModel>> loadPuzzles() async {
    final rawJson = await _loadRawAsset();
    final dynamic decoded;
    try {
      decoded = json.decode(rawJson);
    } on FormatException catch (e) {
      throw PuzzleDataException(
        'The puzzles asset contains invalid JSON. '
        'Re-run the puzzle generator or validate assets/data/puzzles.json.',
        cause: e,
      );
    }

    if (decoded is! List) {
      throw PuzzleDataException(
        'Puzzles asset must be a JSON array but found ${decoded.runtimeType}.',
      );
    }

    final puzzles = <PuzzleModel>[];
    for (final entry in decoded) {
      if (entry is! Map<String, dynamic>) {
        _log(
          'Skipping puzzle entry because it is not an object: ${entry.runtimeType}',
        );
        continue;
      }
      try {
        puzzles.add(PuzzleModel.fromJson(entry));
      } catch (e, stackTrace) {
        _log(
          'Skipping invalid puzzle entry "${entry['id'] ?? '<unknown>'}": $e\n$stackTrace',
        );
      }
    }

    if (puzzles.isEmpty) {
      throw const PuzzleDataException(
        'No valid puzzles were found in $_puzzlesPath. '
        'Ensure the file is populated and matches the expected schema.',
      );
    }

    return puzzles;
  }

  Future<String> _loadRawAsset() async {
    try {
      final raw = await _bundle.loadString(_puzzlesPath);
      final trimmed = raw.trim();
      if (trimmed.isEmpty) {
        throw const PuzzleDataException(
          'Puzzles asset $_puzzlesPath is empty. '
          'Verify the asset is bundled and not zero bytes.',
        );
      }
      return trimmed;
    } on FlutterError catch (e) {
      throw PuzzleDataException(
        'Unable to load puzzles asset at $_puzzlesPath. '
        'Check pubspec.yaml assets configuration and run flutter pub get.',
        cause: e,
      );
    }
  }

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[LocalPuzzleDatasource] $message');
    }
  }
}
