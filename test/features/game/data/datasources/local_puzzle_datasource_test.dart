import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystery_link/features/game/data/datasources/local_puzzle_datasource.dart';
import 'package:mystery_link/features/game/data/datasources/puzzle_data_exception.dart';

void main() {
  group('LocalPuzzleDatasource', () {
    test('parses well-formed puzzle JSON', () async {
      final datasource = LocalPuzzleDatasource(
        bundle: _FakeBundle(_validPuzzleJson),
      );

      final puzzles = await datasource.loadPuzzles();

      expect(puzzles, hasLength(1));
      expect(puzzles.first.id, equals('p1'));
    });

    test('throws when asset is missing', () async {
      final datasource = LocalPuzzleDatasource(
        bundle: _FakeBundle('', error: FlutterError('missing')),
      );

      expect(
        () => datasource.loadPuzzles(),
        throwsA(isA<PuzzleDataException>()),
      );
    });

    test('throws when asset is empty', () async {
      final datasource = LocalPuzzleDatasource(
        bundle: _FakeBundle('   '),
      );

      expect(
        () => datasource.loadPuzzles(),
        throwsA(
          isA<PuzzleDataException>().having(
            (e) => e.message,
            'message',
            contains('empty'),
          ),
        ),
      );
    });

    test('throws when JSON is invalid', () async {
      final datasource = LocalPuzzleDatasource(
        bundle: _FakeBundle('[{]'),
      );

      expect(
        () => datasource.loadPuzzles(),
        throwsA(isA<PuzzleDataException>()),
      );
    });

    test('throws when JSON root is not a list', () async {
      final datasource = LocalPuzzleDatasource(
        bundle: _FakeBundle('{"puzzles": []}'),
      );

      expect(
        () => datasource.loadPuzzles(),
        throwsA(isA<PuzzleDataException>()),
      );
    });
  });
}

class _FakeBundle extends CachingAssetBundle {
  _FakeBundle(this.value, {this.error});

  final String value;
  final FlutterError? error;

  @override
  Future<ByteData> load(String key) {
    throw UnimplementedError();
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (error != null) {
      throw error!;
    }
    return value;
  }
}

const _validPuzzleJson = '''
[
  {
    "id": "p1",
    "type": "text",
    "linksCount": 1,
    "start": {
      "id": "s",
      "label": "Start",
      "representationType": "text"
    },
    "end": {
      "id": "e",
      "label": "End",
      "representationType": "text"
    },
    "steps": [
      {
        "order": 1,
        "options": [
          {
            "node": {
              "id": "mid",
              "label": "Mid",
              "representationType": "text"
            },
            "isCorrect": true
          }
        ]
      }
    ]
  }
]
''';
