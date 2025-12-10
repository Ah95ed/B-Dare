import 'package:flutter_test/flutter_test.dart';
import 'package:mystery_link/features/game/domain/services/game_engine_factory.dart';
import 'package:mystery_link/features/game/domain/entities/game_type.dart';

void main() {
  group('GameEngineFactory', () {
    test('should return MysteryLinkEngine for mysteryLink', () {
      final factory = GameEngineFactory();
      final engine = factory.getEngine(GameType.mysteryLink);

      expect(engine.gameType, GameType.mysteryLink);
    });

    test('should return MemoryFlipEngine for memoryFlip', () {
      final factory = GameEngineFactory();
      final engine = factory.getEngine(GameType.memoryFlip);

      expect(engine.gameType, GameType.memoryFlip);
    });

    test('should return SpotTheOddEngine for spotTheOdd', () {
      final factory = GameEngineFactory();
      final engine = factory.getEngine(GameType.spotTheOdd);

      expect(engine.gameType, GameType.spotTheOdd);
    });

    test('should use singleton pattern', () {
      final factory1 = GameEngineFactory();
      final factory2 = GameEngineFactory();

      expect(factory1, same(factory2));
    });

    test('should cache engines', () {
      final factory = GameEngineFactory();
      final engine1 = factory.getEngine(GameType.mysteryLink);
      final engine2 = factory.getEngine(GameType.mysteryLink);

      expect(engine1, same(engine2));
    });
  });
}

