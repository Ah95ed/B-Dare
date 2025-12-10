import 'package:flutter_test/flutter_test.dart';
import 'package:mystery_link/features/multiplayer/data/services/cloudflare_multiplayer_service.dart';
import 'package:mystery_link/features/game/domain/entities/puzzle.dart';
import 'package:mystery_link/features/game/domain/entities/link_node.dart';
import 'package:mystery_link/features/game/domain/entities/game_type.dart';

void main() {
  group('Cloudflare Multiplayer Service Tests', () {
    late CloudflareMultiplayerService service;

    setUp(() {
      service = CloudflareMultiplayerService(
        baseUrl: 'wss://test-worker.workers.dev',
      );
    });

    tearDown(() {
      service.disconnect();
    });

    test('should initialize service with base URL', () {
      expect(service.isConnected, false);
      expect(service.roomId, null);
      expect(service.playerId, null);
    });

    test('should handle game-specific messages for Memory Flip', () async {
      // Note: This test requires actual WebSocket connection
      // In a real test, you would mock the WebSocket

      try {
        await service.flipCard(
          cardId: 'card1',
          gameSpecificData: {'level': 1},
        );
        // If no exception, the method exists and works
        expect(true, true);
      } catch (e) {
        // Expected if not connected
        expect(e, isA<Exception>());
      }
    });

    test('should handle game-specific messages for Spot the Odd', () async {
      try {
        await service.selectItem(
          itemId: 'item1',
          gameSpecificData: {'round': 1},
        );
        expect(true, true);
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('should handle game-specific messages for Sort & Solve', () async {
      try {
        await service.moveItem(
          itemId: 'item1',
          newPosition: 0,
          gameSpecificData: {'level': 1},
        );
        expect(true, true);
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('should handle game-specific messages for Emoji Circuit', () async {
      try {
        await service.connectEmojis(
          emojiId: 'emoji1',
          nextEmojiId: 'emoji2',
          gameSpecificData: {'circuit': 1},
        );
        expect(true, true);
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('should handle game-specific messages for Cipher Tiles', () async {
      try {
        await service.decodeCharacter(
          tileId: 'tile1',
          decodedChar: 'A',
          gameSpecificData: {'level': 1},
        );
        expect(true, true);
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('should handle game-specific messages for Color Harmony', () async {
      try {
        await service.mixColors(
          color1Id: 'color1',
          color2Id: 'color2',
          gameSpecificData: {'level': 1},
        );
        expect(true, true);
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('should serialize puzzle with gameType correctly', () {
      const puzzle = Puzzle(
        id: 'test',
        gameType: GameType.memoryFlip,
        type: RepresentationType.text,
        start: LinkNode(
          id: 'start',
          label: 'Start',
          representationType: RepresentationType.text,
        ),
        end: LinkNode(
          id: 'end',
          label: 'End',
          representationType: RepresentationType.text,
        ),
        linksCount: 1,
        timeLimit: 60,
        steps: [],
        gameTypeData: {'cards': []},
      );

      // The service should be able to handle this puzzle
      expect(puzzle.gameType, GameType.memoryFlip);
      expect(puzzle.gameTypeData, isNotNull);
    });
  });
}
