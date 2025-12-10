import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../../../../features/game/domain/entities/puzzle.dart';
import '../../../../features/game/domain/entities/link_node.dart';
import '../../../../features/game/domain/entities/game_type.dart';
import '../../../../core/constants/app_constants.dart';

/// Service للاتصال بـ Cloudflare Workers backend للعب الجماعي المزامن
class CloudflareMultiplayerService {
  WebSocketChannel? _channel;
  final String? _baseUrl;

  String? get roomId => _roomId;
  String? get playerId => _playerId;

  String? _roomId;
  String? _playerId;

  final StreamController<MultiplayerMessage> _messageController =
      StreamController<MultiplayerMessage>.broadcast();

  Stream<MultiplayerMessage> get messageStream => _messageController.stream;

  bool get isConnected => _channel != null;

  /// تهيئة Service مع URL الخادم
  CloudflareMultiplayerService({String? baseUrl})
    : _baseUrl = baseUrl ?? AppConstants.cloudflareWorkerUrl;

  /// الاتصال بغرفة لعبة
  Future<void> connectToRoom({
    required String roomId,
    required String playerId,
    required String playerName,
  }) async {
    if (_channel != null) {
      await disconnect();
    }

    _roomId = roomId;
    _playerId = playerId;

    final url =
        '$_baseUrl/game/$roomId?playerId=$playerId&playerName=${Uri.encodeComponent(playerName)}';

    int retryCount = 0;
    const maxRetries = 3;
    const retryDelays = [1000, 2000, 5000]; // milliseconds

    while (retryCount <= maxRetries) {
      try {
        if (retryCount > 0) {
          await Future.delayed(
            Duration(milliseconds: retryDelays[retryCount - 1]),
          );
        }

        _channel = WebSocketChannel.connect(Uri.parse(url));

        _channel!.stream.listen(
          (message) {
            try {
              final data =
                  jsonDecode(message as String) as Map<String, dynamic>;
              _messageController.add(MultiplayerMessage.fromJson(data));
            } catch (e) {
              debugPrint('Error parsing message: $e');
              _messageController.add(
                MultiplayerMessage(
                  type: 'error',
                  data: {'message': 'Failed to parse message: $e'},
                ),
              );
            }
          },
          onError: (error) {
            debugPrint('WebSocket error: $error');
            _messageController.add(
              MultiplayerMessage(
                type: 'error',
                data: {'message': error.toString()},
              ),
            );
            // محاولة إعادة الاتصال
            _attemptReconnect(
              roomId,
              playerId,
              playerName,
              retryCount,
              maxRetries,
            );
          },
          onDone: () {
            debugPrint('WebSocket closed');
            _messageController.add(
              MultiplayerMessage(type: 'disconnected', data: {}),
            );
            // محاولة إعادة الاتصال
            _attemptReconnect(
              roomId,
              playerId,
              playerName,
              retryCount,
              maxRetries,
            );
          },
          cancelOnError: false,
        );

        // نجح الاتصال
        break;
      } catch (e) {
        debugPrint('Error connecting to room (attempt ${retryCount + 1}): $e');
        retryCount++;

        if (retryCount > maxRetries) {
          _messageController.add(
            MultiplayerMessage(
              type: 'error',
              data: {'message': 'Failed to connect after $maxRetries attempts'},
            ),
          );
          rethrow;
        }
      }
    }
  }

  Future<void> _attemptReconnect(
    String roomId,
    String playerId,
    String playerName,
    int currentRetry,
    int maxRetries,
  ) async {
    if (currentRetry >= maxRetries) return;

    try {
      await Future.delayed(Duration(seconds: 2 * (currentRetry + 1)));
      await connectToRoom(
        roomId: roomId,
        playerId: playerId,
        playerName: playerName,
      );
    } catch (e) {
      debugPrint('Reconnection attempt failed: $e');
    }
  }

  /// إرسال رسالة للخادم
  Future<void> sendMessage(Map<String, dynamic> message) async {
    if (_channel == null) {
      throw Exception('Not connected to room');
    }

    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        _channel!.sink.add(jsonEncode(message));
        return; // نجح الإرسال
      } catch (e) {
        retryCount++;
        debugPrint('Error sending message (attempt $retryCount): $e');

        if (retryCount >= maxRetries) {
          throw Exception(
            'Failed to send message after $maxRetries attempts: $e',
          );
        }

        // انتظار قبل إعادة المحاولة
        await Future.delayed(Duration(milliseconds: 500 * retryCount));
      }
    }
  }

  /// إرسال flip card (Memory Flip)
  Future<void> flipCard({
    required String cardId,
    Map<String, dynamic>? gameSpecificData,
  }) async {
    await sendMessage({
      'type': 'flipCard',
      'cardId': cardId,
      ...?gameSpecificData,
    });
  }

  /// إرسال select item (Spot the Odd, Shadow Match, Spot the Change)
  Future<void> selectItem({
    required String itemId,
    Map<String, dynamic>? gameSpecificData,
  }) async {
    await sendMessage({
      'type': 'selectItem',
      'itemId': itemId,
      ...?gameSpecificData,
    });
  }

  /// إرسال move item (Sort & Solve, Story Tiles, Puzzle Sentence)
  Future<void> moveItem({
    required String itemId,
    required int newPosition,
    Map<String, dynamic>? gameSpecificData,
  }) async {
    await sendMessage({
      'type': 'moveItem',
      'itemId': itemId,
      'newPosition': newPosition,
      ...?gameSpecificData,
    });
  }

  /// إرسال arrange tiles (Story Tiles)
  Future<void> arrangeTiles({
    required String tileId,
    required int newPosition,
    Map<String, dynamic>? gameSpecificData,
  }) async {
    await sendMessage({
      'type': 'arrangeTiles',
      'tileId': tileId,
      'newPosition': newPosition,
      ...?gameSpecificData,
    });
  }

  /// إرسال emoji connection (Emoji Circuit)
  Future<void> connectEmojis({
    required String emojiId,
    required String nextEmojiId,
    Map<String, dynamic>? gameSpecificData,
  }) async {
    await sendMessage({
      'type': 'connectEmojis',
      'emojiId': emojiId,
      'nextEmojiId': nextEmojiId,
      ...?gameSpecificData,
    });
  }

  /// إرسال decoded character (Cipher Tiles)
  Future<void> decodeCharacter({
    required String tileId,
    required String decodedChar,
    Map<String, dynamic>? gameSpecificData,
  }) async {
    await sendMessage({
      'type': 'decodeCharacter',
      'tileId': tileId,
      'decodedChar': decodedChar,
      ...?gameSpecificData,
    });
  }

  /// إرسال color mix (Color Harmony)
  Future<void> mixColors({
    required String color1Id,
    required String color2Id,
    Map<String, dynamic>? gameSpecificData,
  }) async {
    await sendMessage({
      'type': 'mixColors',
      'color1Id': color1Id,
      'color2Id': color2Id,
      ...?gameSpecificData,
    });
  }

  /// بدء اللعبة
  Future<void> startGame({
    required String representationType,
    required int linksCount,
    String? category,
    Puzzle? puzzle, // يمكن إرسال اللغز كاملاً من Flutter
    String? gameType,
  }) async {
    await sendMessage({
      'type': 'startGame',
      'config': {
        'gameType':
            gameType ??
            (puzzle?.gameType != null ? puzzle!.gameType.value : 'mysteryLink'),
        'representationType': representationType,
        'linksCount': linksCount,
        'category': category,
        'puzzleId': puzzle?.id,
        'puzzle': puzzle != null ? _puzzleToJson(puzzle) : null,
      },
    });
  }

  Map<String, dynamic> _puzzleToJson(Puzzle puzzle) {
    return {
      'id': puzzle.id,
      'gameType': puzzle.gameType.value,
      'type': puzzle.type.name,
      'category': puzzle.category,
      'difficulty': puzzle.difficulty,
      'linksCount': puzzle.linksCount,
      'timeLimit': puzzle.timeLimit,
      'gameTypeData': puzzle.gameTypeData,
      // يمكن إضافة المزيد من الحقول حسب الحاجة
    };
  }

  /// اختيار إجابة
  Future<void> selectOption({
    required LinkNode selectedNode,
    required int stepOrder,
  }) async {
    await sendMessage({
      'type': 'selectOption',
      'selectedNode': {
        'id': selectedNode.id,
        'label': selectedNode.label,
        'representationType': selectedNode.representationType.name,
      },
      'stepOrder': stepOrder,
    });
  }

  /// طلب حالة اللعبة الحالية
  Future<void> requestGameState() async {
    await sendMessage({'type': 'requestGameState'});
  }

  /// قطع الاتصال
  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
    _roomId = null;
    _playerId = null;
  }

  /// تنظيف الموارد
  void dispose() {
    disconnect();
    _messageController.close();
  }
}

/// نموذج للرسائل الواردة من الخادم
class MultiplayerMessage {
  final String type;
  final Map<String, dynamic> data;

  MultiplayerMessage({required this.type, required this.data});

  factory MultiplayerMessage.fromJson(Map<String, dynamic> json) {
    return MultiplayerMessage(
      type: json['type'] as String? ?? 'unknown',
      data: json,
    );
  }

  // Helper methods للوصول السريع للبيانات الشائعة
  bool get isGameStarted => type == 'gameStarted';
  bool get isStepCompleted => type == 'stepCompleted';
  bool get isWrongAnswer => type == 'wrongAnswer';
  bool get isGameCompleted => type == 'gameCompleted';
  bool get isGameTimeout => type == 'gameTimeout';
  bool get isPlayerJoined => type == 'playerJoined';
  bool get isPlayerLeft => type == 'playerLeft';
  bool get isTimerTick => type == 'timerTick';
  bool get isError => type == 'error';
  bool get isConnected => type == 'connected';
  bool get isDisconnected => type == 'disconnected';
}

/// Helper class لإنشاء غرف جديدة
class CloudflareRoomCreator {
  final String baseUrl;

  CloudflareRoomCreator({String? baseUrl})
    : baseUrl = baseUrl ?? AppConstants.cloudflareWorkerHttpUrl;

  /// إنشاء غرفة جديدة
  Future<RoomInfo> createRoom() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/create-room'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return RoomInfo.fromJson(data);
      } else {
        throw Exception('Failed to create room: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create room: $e');
    }
  }

  /// الحصول على معلومات الغرفة
  Future<RoomInfo> getRoomInfo(String roomId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/room/$roomId'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return RoomInfo.fromJson(data);
      } else {
        throw Exception('Failed to get room info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get room info: $e');
    }
  }
}

/// معلومات الغرفة
class RoomInfo {
  final String roomId;
  final String? wsUrl;
  final String? status;

  RoomInfo({required this.roomId, this.wsUrl, this.status});

  factory RoomInfo.fromJson(Map<String, dynamic> json) {
    return RoomInfo(
      roomId: json['roomId'] as String,
      wsUrl: json['wsUrl'] as String?,
      status: json['status'] as String?,
    );
  }
}
