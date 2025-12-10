import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;

import '../../../../core/constants/app_constants.dart';

class TournamentLiveUpdate {
  final String eventType;
  final String? tournamentId;
  final DateTime timestamp;
  final Map<String, dynamic> payload;

  TournamentLiveUpdate({
    required this.eventType,
    required this.tournamentId,
    required this.timestamp,
    required this.payload,
  });
}

class TournamentLiveService {
  TournamentLiveService({
    this.reconnectDelay = const Duration(seconds: 5),
    String? baseWebSocketUrl,
  }) : _baseWebSocketUrl = baseWebSocketUrl ?? AppConstants.cloudflareWorkerUrl;

  final Duration reconnectDelay;
  final String _baseWebSocketUrl;
  WebSocketChannel? _channel;
  StreamController<TournamentLiveUpdate>? _controller;
  Timer? _reconnectTimer;
  bool _manuallyClosed = false;
  String? _activeTournamentId;

  Stream<TournamentLiveUpdate> watch({String? tournamentId}) {
    _activeTournamentId = tournamentId;
    _closeChannel();
    _controller?.close();
    _controller = StreamController<TournamentLiveUpdate>.broadcast(
      onListen: () => _connect(),
      onCancel: _closeChannel,
    );
    if (_controller!.hasListener) {
      _connect();
    }
    return _controller!.stream;
  }

  void _connect() {
    final tournamentId = _activeTournamentId;
    _manuallyClosed = false;
    _reconnectTimer?.cancel();
    final uri = _buildUri(tournamentId);
    try {
      _channel = WebSocketChannel.connect(uri);
      _channel!.stream.listen(
        (message) => _handleMessage(message, tournamentId),
        onError: _handleError,
        onDone: _handleDone,
        cancelOnError: true,
      );
    } catch (error) {
      _handleError(error);
    }
  }

  Uri _buildUri(String? tournamentId) {
    final base = Uri.parse(_baseWebSocketUrl);
    final scheme = base.scheme == 'https'
        ? 'wss'
        : base.scheme == 'http'
            ? 'ws'
            : base.scheme;
    final normalizedSegments = <String>[
      ...base.pathSegments.where((s) => s.isNotEmpty),
      'api',
      'tournaments',
      tournamentId ?? 'global-feed',
      'ws'
    ];
    return base.replace(scheme: scheme, pathSegments: normalizedSegments);
  }

  void _handleMessage(dynamic message, String? tournamentId) {
    if (_controller?.isClosed ?? true) return;
    try {
      final decoded = jsonDecode(message as String);
      if (decoded is List) {
        for (final item in decoded) {
          _emitUpdate(item as Map<String, dynamic>, tournamentId);
        }
      } else if (decoded is Map<String, dynamic>) {
        _emitUpdate(decoded, tournamentId);
      }
    } catch (e) {
      _controller?.addError(e);
    }
  }

  void _emitUpdate(Map<String, dynamic> raw, String? fallbackId) {
    final timestampField = raw['timestamp'];
    DateTime timestamp;
    if (timestampField is num) {
      timestamp = DateTime.fromMillisecondsSinceEpoch(timestampField.toInt());
    } else if (timestampField is String) {
      timestamp = DateTime.tryParse(timestampField) ?? DateTime.now();
    } else {
      timestamp = DateTime.now();
    }

    final update = TournamentLiveUpdate(
      eventType: raw['type'] as String? ?? 'update',
      tournamentId: raw['data']?['tournament']?['id'] as String? ?? fallbackId,
      timestamp: timestamp,
      payload: (raw['data'] as Map<String, dynamic>?) ?? raw,
    );
    _controller?.add(update);
  }

  void _handleError(dynamic error) {
    if (_controller?.isClosed ?? true) return;
    _controller?.addError(error);
    _scheduleReconnect();
  }

  void _handleDone() {
    if (_manuallyClosed) return;
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_manuallyClosed || (_reconnectTimer?.isActive ?? false)) return;
    _reconnectTimer = Timer(reconnectDelay, () {
      if (_controller == null || (_controller?.isClosed ?? true)) {
        return;
      }
      _connect();
    });
  }

  void _closeChannel() {
    _manuallyClosed = true;
    _reconnectTimer?.cancel();
    _channel?.sink.close(ws_status.normalClosure);
    _channel = null;
  }

  void dispose() {
    _controller?.close();
    _controller = null;
    _closeChannel();
  }
}
