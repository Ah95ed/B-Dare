import 'game_engine_interface.dart';
import '../../domain/entities/game_type.dart';
import 'engines/mystery_link_engine.dart';
import 'engines/memory_flip_engine.dart';
import 'engines/spot_the_odd_engine.dart';
import 'engines/sort_solve_engine.dart';
import 'engines/story_tiles_engine.dart';
import 'engines/shadow_match_engine.dart';
import 'engines/emoji_circuit_engine.dart';
import 'engines/cipher_tiles_engine.dart';
import 'engines/spot_the_change_engine.dart';
import 'engines/color_harmony_engine.dart';
import 'engines/puzzle_sentence_engine.dart';

/// Factory لإنشاء Game Engine المناسب حسب GameType
class GameEngineFactory {
  static final GameEngineFactory _instance = GameEngineFactory._internal();
  factory GameEngineFactory() => _instance;
  GameEngineFactory._internal();

  final Map<GameType, GameEngine> _engines = {};

  /// الحصول على Engine حسب GameType
  GameEngine getEngine(GameType gameType) {
    if (_engines.containsKey(gameType)) {
      return _engines[gameType]!;
    }

    // إنشاء Engine جديد
    final engine = _createEngine(gameType);
    _engines[gameType] = engine;
    return engine;
  }

  /// إنشاء Engine جديد
  GameEngine _createEngine(GameType gameType) {
    switch (gameType) {
      case GameType.mysteryLink:
        return MysteryLinkEngine();
      case GameType.memoryFlip:
        return MemoryFlipEngine();
      case GameType.spotTheOdd:
        return SpotTheOddEngine();
      case GameType.sortSolve:
        return SortSolveEngine();
      case GameType.storyTiles:
        return StoryTilesEngine();
      case GameType.shadowMatch:
        return ShadowMatchEngine();
      case GameType.emojiCircuit:
        return EmojiCircuitEngine();
      case GameType.cipherTiles:
        return CipherTilesEngine();
      case GameType.spotTheChange:
        return SpotTheChangeEngine();
      case GameType.colorHarmony:
        return ColorHarmonyEngine();
      case GameType.puzzleSentence:
        return PuzzleSentenceEngine();
    }
  }

  /// إعادة تعيين جميع Engines (للتطوير والاختبار)
  void reset() {
    _engines.clear();
  }
}

