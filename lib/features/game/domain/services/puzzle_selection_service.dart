import '../../domain/entities/puzzle.dart';
import '../../domain/entities/link_node.dart' show RepresentationType;
import '../../domain/repositories/puzzle_repository_interface.dart';
import '../../../progression/data/services/progression_service.dart';
import '../../../../core/constants/progression_constants.dart';

class PuzzleSelectionOutcome {
  final Puzzle? puzzle;
  final String? notice;

  const PuzzleSelectionOutcome({
    this.puzzle,
    this.notice,
  });

  bool get hasPuzzle => puzzle != null;
}

class PuzzleSelectionService {
  final PuzzleRepositoryInterface _repository;
  final ProgressionService? _progressionService;
  final Map<String, List<String>> _phaseCulturePacks;

  PuzzleSelectionService(
    this._repository, {
    ProgressionService? progressionService,
    Map<String, List<String>> phaseCulturePacks = const {},
  })  : _progressionService = progressionService,
        _phaseCulturePacks = phaseCulturePacks;

  Future<PuzzleSelectionOutcome> resolve({
    required RepresentationType requestedType,
    required int requestedLinks,
    String? requestedCategory,
  }) async {
    final normalizedCategory = requestedCategory?.trim();
    final recommendedCategory =
        await _recommendedCategoryForPhase(normalizedCategory);
    final attempts = <_PuzzleQuery>[
      _PuzzleQuery(
        type: requestedType,
        category: normalizedCategory,
      ),
      _PuzzleQuery(type: requestedType, category: null),
      if (normalizedCategory != null)
        _PuzzleQuery(type: null, category: normalizedCategory),
      const _PuzzleQuery(),
    ];

    for (var index = 0; index < attempts.length; index++) {
      final query = attempts[index];
      final puzzle = await _repository.getRandomPuzzle(
        type: query.type,
        linksCount: requestedLinks,
        category: query.category ?? recommendedCategory,
      );

      if (puzzle != null) {
        final notice = _buildNotice(
          puzzle: puzzle,
          requestedType: requestedType,
          requestedCategory: normalizedCategory,
          requestedLinks: requestedLinks,
        );
        final usedFallback = index > 0;
        return PuzzleSelectionOutcome(
          puzzle: puzzle,
          notice: usedFallback ? notice ?? _defaultFallbackMessage : notice,
        );
      }
    }

    return const PuzzleSelectionOutcome();
  }

  Future<String?> _recommendedCategoryForPhase(String? requestedCategory) async {
    if (requestedCategory != null && requestedCategory.isNotEmpty) {
      return requestedCategory;
    }
    if (_progressionService == null || _phaseCulturePacks.isEmpty) {
      return null;
    }
    try {
      final progress = await _progressionService!.getProgress();
      final currentPhase =
          ProgressionConstants.phaseByIndex(progress.unlockedPhaseIndex);
      final packs = _phaseCulturePacks[currentPhase.id];
      if (packs == null || packs.isEmpty) return null;
      return packs.first;
    } catch (_) {
      return null;
    }
  }

  String? _buildNotice({
    required Puzzle puzzle,
    required RepresentationType requestedType,
    String? requestedCategory,
    required int requestedLinks,
  }) {
    final missingParts = <String>[];
    final fallbackParts = <String>[];

    if (puzzle.type != requestedType) {
      missingParts.add('${_typeLabel(requestedType)} representation');
      fallbackParts.add('${_typeLabel(puzzle.type)} representation');
    }

    if (requestedCategory != null) {
      final normalizedPuzzleCategory = puzzle.category?.trim().toLowerCase();
      final normalizedRequested = requestedCategory.toLowerCase();
      if (normalizedPuzzleCategory != normalizedRequested) {
        missingParts.add('theme "$requestedCategory"');
        fallbackParts.add(
          puzzle.category != null
              ? 'theme "${puzzle.category}"'
              : 'a general theme',
        );
      }
    }

    if (puzzle.linksCount != requestedLinks) {
      missingParts.add('$requestedLinks links');
      fallbackParts.add('${puzzle.linksCount} links');
    }

    if (missingParts.isEmpty) {
      return null;
    }

    final missing = missingParts.join(', ');
    final fallback = fallbackParts.join(', ');
    return 'No puzzle matched $missing. Showing $fallback instead.';
  }

  String get _defaultFallbackMessage =>
      'No puzzle matched all filters. Showing a recommended puzzle instead.';

  String _typeLabel(RepresentationType type) {
    switch (type) {
      case RepresentationType.text:
        return 'Text';
      case RepresentationType.icon:
        return 'Icon';
      case RepresentationType.image:
        return 'Image';
      case RepresentationType.event:
        return 'Event';
    }
  }
}

class _PuzzleQuery {
  final RepresentationType? type;
  final String? category;

  const _PuzzleQuery({
    this.type,
    this.category,
  });
}
