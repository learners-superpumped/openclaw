import 'dart:async';
import 'dart:convert';

import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../constants.dart';
import '../models/chat_session.dart';

const _uuid = Uuid();

class ChatService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  final _pendingRequests = <String, Completer<Map<String, dynamic>>>{};
  final _eventController = StreamController<Map<String, dynamic>>.broadcast();

  bool _isConnected = false;
  bool _isDisposed = false;
  String? _instanceId;
  String? _accessToken;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;

  /// Raw event stream for providers to subscribe to.
  Stream<Map<String, dynamic>> get events => _eventController.stream;

  bool get isConnected => _isConnected;

  /// Connect to the chat WebSocket and perform handshake authentication.
  Future<void> connect(String instanceId, String accessToken) async {
    _instanceId = instanceId;
    _accessToken = accessToken;
    _reconnectAttempts = 0;
    await _connect();
  }

  Future<void> _connect() async {
    if (_isDisposed) return;

    // Clean up previous connection before reconnecting
    _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close();
    _channel = null;

    final wsUrl = apiBaseUrl.replaceFirst('https://', 'wss://');
    final uri = Uri.parse('$wsUrl/instances/$_instanceId/chat');

    _channel = WebSocketChannel.connect(uri);

    final authCompleter = Completer<void>();

    _subscription = _channel!.stream.listen(
      (raw) {
        final data = jsonDecode(raw as String) as Map<String, dynamic>;
        final type = data['type'] as String?;

        if (type == 'auth_required') {
          // Step 2: Server requests authentication
          _channel!.sink.add(jsonEncode({
            'type': 'auth',
            'token': _accessToken,
          }));
          return;
        }

        if (type == 'auth_ok') {
          // Authentication complete
          _isConnected = true;
          _reconnectAttempts = 0;
          if (!authCompleter.isCompleted) {
            authCompleter.complete();
          }
          return;
        }

        if (type == 'auth_error') {
          _isConnected = false;
          if (!authCompleter.isCompleted) {
            authCompleter.completeError(
              Exception(data['message'] ?? 'Authentication failed'),
            );
          }
          return;
        }

        if (type == 'res') {
          // RPC response
          final id = data['id'] as String?;
          if (id != null && _pendingRequests.containsKey(id)) {
            _pendingRequests.remove(id)!.complete(data);
          }
          return;
        }

        if (type == 'event') {
          // Push event (streaming, etc.)
          _eventController.add(data);
          return;
        }
      },
      onError: (error) {
        _isConnected = false;
        if (!authCompleter.isCompleted) {
          authCompleter.completeError(error);
        }
        _handleDisconnect();
      },
      onDone: () {
        _isConnected = false;
        if (!authCompleter.isCompleted) {
          authCompleter.completeError(Exception('Connection closed'));
        }
        _handleDisconnect();
      },
    );

    return authCompleter.future;
  }

  void _handleDisconnect() {
    _isConnected = false;
    // Fail all pending requests
    for (final completer in _pendingRequests.values) {
      if (!completer.isCompleted) {
        completer.completeError(Exception('Connection lost'));
      }
    }
    _pendingRequests.clear();

    // Auto-reconnect with exponential backoff
    if (!_isDisposed && _reconnectAttempts < _maxReconnectAttempts) {
      _reconnectAttempts++;
      final delay = Duration(
        seconds: (2 << (_reconnectAttempts - 1)).clamp(2, 32),
      );
      Future.delayed(delay, () async {
        if (!_isDisposed && !_isConnected) {
          try {
            await _connect();
          } catch (_) {
            // Reconnect failure handled by next _handleDisconnect cycle
          }
        }
      });
    }
  }

  /// Send an RPC request and await the response.
  Future<Map<String, dynamic>> sendRpc(
    String method, [
    Map<String, dynamic>? params,
  ]) async {
    if (!_isConnected || _channel == null) {
      throw Exception('Not connected');
    }

    final id = _uuid.v4();
    final completer = Completer<Map<String, dynamic>>();
    _pendingRequests[id] = completer;

    _channel!.sink.add(jsonEncode({
      'type': 'req',
      'id': id,
      'method': method,
      if (params != null) 'params': params,
    }));

    // 60s timeout
    return completer.future.timeout(
      const Duration(seconds: 60),
      onTimeout: () {
        _pendingRequests.remove(id);
        throw TimeoutException('RPC request timed out: $method');
      },
    );
  }

  /// Send a chat message with optional image attachments.
  Future<Map<String, dynamic>> sendChatMessage({
    required String sessionKey,
    required String message,
    required String idempotencyKey,
    List<Map<String, dynamic>>? attachments,
  }) {
    return sendRpc('chat.send', {
      'sessionKey': sessionKey,
      'message': message,
      'idempotencyKey': idempotencyKey,
      if (attachments != null && attachments.isNotEmpty)
        'attachments': attachments,
    });
  }

  /// Abort the current chat response.
  Future<Map<String, dynamic>> abortChat({required String sessionKey}) {
    return sendRpc('chat.abort', {'sessionKey': sessionKey});
  }

  /// Load chat history for a session.
  Future<Map<String, dynamic>> loadHistory({
    required String sessionKey,
    int limit = 200,
  }) {
    return sendRpc('chat.history', {
      'sessionKey': sessionKey,
      'limit': limit.clamp(1, 1000),
    });
  }

  /// List available sessions.
  Future<List<ChatSession>> listSessions() async {
    final res = await sendRpc('sessions.list', {
      'includeDerivedTitles': true,
    });
    final ok = res['ok'] as bool? ?? false;
    if (!ok) {
      throw Exception(res['error'] ?? 'Failed to list sessions');
    }
    final payload = res['payload'] as Map<String, dynamic>?;
    final sessions = payload?['sessions'] as List<dynamic>? ?? [];
    return sessions
        .map((s) => ChatSession.fromJson(s as Map<String, dynamic>))
        .toList();
  }

  /// Disconnect and clean up resources.
  void disconnect() {
    _isDisposed = true;
    _isConnected = false;
    _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close();
    _channel = null;

    for (final completer in _pendingRequests.values) {
      if (!completer.isCompleted) {
        completer.completeError(Exception('Disconnected'));
      }
    }
    _pendingRequests.clear();
  }

  /// Dispose all resources including the event stream.
  void dispose() {
    disconnect();
    _eventController.close();
  }
}
