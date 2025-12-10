import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mystery_link/features/game/domain/entities/link_node.dart';
import 'package:mystery_link/features/game/domain/entities/puzzle.dart';
import 'package:mystery_link/features/game/domain/entities/puzzle_step.dart';
import 'package:mystery_link/features/game/domain/repositories/puzzle_repository_interface.dart';
import 'package:mystery_link/features/game/domain/services/puzzle_selection_service.dart';

class _MockPuzzleRepository extends Mock implements PuzzleRepositoryInterface {}

void main() {
  late _MockPuzzleRepository repository;
  late PuzzleSelectionService service;
  const puzzle = Puzzle(
    id: 'p1',
    type: RepresentationType.text,
    start: LinkNode(
      id: 's',
      label: 'Start',
      representationType: RepresentationType.text,
    ),
    end: LinkNode(
      id: 'e',
      label: 'End',
      representationType: RepresentationType.text,
    ),
    linksCount: 1,
    steps: [
      PuzzleStep(
        order: 1,
        options: [
          StepOption(
            node: LinkNode(
              id: 'mid',
              label: 'Mid',
              representationType: RepresentationType.text,
            ),
            isCorrect: true,
          ),
        ],
      ),
    ],
    category: 'Science',
  );

  setUp(() {
    repository = _MockPuzzleRepository();
    service = PuzzleSelectionService(repository);
  });

  test('returns puzzle without notice when exact match exists', () async {
    when(() => repository.getRandomPuzzle(
          type: RepresentationType.text,
          linksCount: 1,
          difficulty: any(named: 'difficulty'),
          category: 'Science',
        )).thenAnswer((_) async => puzzle);

    final result = await service.resolve(
      requestedType: RepresentationType.text,
      requestedLinks: 1,
      requestedCategory: 'Science',
    );

    expect(result.puzzle, equals(puzzle));
    expect(result.notice, isNull);
  });

  test('falls back when category is missing', () async {
    when(() => repository.getRandomPuzzle(
          type: RepresentationType.icon,
          linksCount: 1,
          difficulty: any(named: 'difficulty'),
          category: 'Science',
        )).thenAnswer((_) async => null);

    when(() => repository.getRandomPuzzle(
          type: RepresentationType.icon,
          linksCount: 1,
          difficulty: any(named: 'difficulty'),
          category: null,
        )).thenAnswer((_) async => puzzle);

    final result = await service.resolve(
      requestedType: RepresentationType.icon,
      requestedLinks: 1,
      requestedCategory: 'Science',
    );

    expect(result.puzzle, equals(puzzle));
    expect(result.notice, isNotNull);
  });

  test('returns empty outcome when no puzzle exists', () async {
    when(() => repository.getRandomPuzzle(
          type: any(named: 'type'),
          linksCount: any(named: 'linksCount'),
          difficulty: any(named: 'difficulty'),
          category: any(named: 'category'),
        )).thenAnswer((_) async => null);

    final result = await service.resolve(
      requestedType: RepresentationType.icon,
      requestedLinks: 5,
      requestedCategory: 'Science',
    );

    expect(result.puzzle, isNull);
    expect(result.notice, isNull);
  });
}
