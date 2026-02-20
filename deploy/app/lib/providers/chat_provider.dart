import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/chat_message.dart';
import '../models/chat_session.dart';
import '../services/chat_service.dart';
import 'api_provider.dart';

const _uuid = Uuid();

enum ChatConnectionState {
  disconnected,
  connecting,
  authenticating,
  connected,
  error,
}

class ChatState {
  final ChatConnectionState connectionState;
  final List<ChatMessage> messages;
  final List<ChatSession> sessions;
  final String? currentSessionKey;
  final bool isAgentRunning;
  final String streamingContent;
  final String? error;

  const ChatState({
    this.connectionState = ChatConnectionState.disconnected,
    this.messages = const [],
    this.sessions = const [],
    this.currentSessionKey,
    this.isAgentRunning = false,
    this.streamingContent = '',
    this.error,
  });

  /// Derive session name from sessions list for display.
  String? get currentSessionName {
    if (currentSessionKey == null) return null;
    final session = sessions.where((s) => s.key == currentSessionKey);
    if (session.isEmpty) return null;
    return session.first.title;
  }

  /// Build a streaming ChatMessage if content is being streamed.
  ChatMessage? get streamingMessage {
    if (streamingContent.isEmpty && !isAgentRunning) return null;
    return ChatMessage(
      id: 'streaming',
      role: 'assistant',
      content: streamingContent,
      timestamp: DateTime.now(),
      isStreaming: true,
    );
  }

  ChatState copyWith({
    ChatConnectionState? connectionState,
    List<ChatMessage>? messages,
    List<ChatSession>? sessions,
    String? currentSessionKey,
    bool? isAgentRunning,
    String? streamingContent,
    String? error,
  }) {
    return ChatState(
      connectionState: connectionState ?? this.connectionState,
      messages: messages ?? this.messages,
      sessions: sessions ?? this.sessions,
      currentSessionKey: currentSessionKey ?? this.currentSessionKey,
      isAgentRunning: isAgentRunning ?? this.isAgentRunning,
      streamingContent: streamingContent ?? this.streamingContent,
      error: error,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  static const _defaultSessionKey = 'agent:main:main';

  final Ref _ref;
  ChatService? _chatService;
  StreamSubscription? _eventSubscription;

  ChatNotifier(this._ref) : super(const ChatState());

  /// Connect to the chat WebSocket for the given instance.
  Future<void> connect(String instanceId) async {
    if (state.connectionState == ChatConnectionState.connecting ||
        state.connectionState == ChatConnectionState.authenticating) {
      return;
    }

    state = state.copyWith(
      connectionState: ChatConnectionState.connecting,
      error: null,
    );

    try {
      final storage = _ref.read(secureStorageProvider);
      final accessToken = await storage.read(key: 'access_token');
      if (accessToken == null) {
        state = state.copyWith(
          connectionState: ChatConnectionState.error,
          error: 'No access token found',
        );
        return;
      }

      state = state.copyWith(
        connectionState: ChatConnectionState.authenticating,
      );

      _chatService?.dispose();
      _chatService = ChatService();
      _listenToEvents();

      await _chatService!.connect(instanceId, accessToken);

      state = state.copyWith(
        connectionState: ChatConnectionState.connected,
      );

      // Load sessions and history after connection
      await _loadInitialData();
    } catch (e) {
      state = state.copyWith(
        connectionState: ChatConnectionState.error,
        error: e.toString(),
      );
    }
  }

  /// Disconnect from the chat WebSocket.
  void disconnect() {
    _eventSubscription?.cancel();
    _eventSubscription = null;
    _chatService?.dispose();
    _chatService = null;
    state = const ChatState();
  }

  /// Send a user message with optional image attachments.
  Future<void> sendMessage(
    String text, {
    List<ChatAttachment>? images,
  }) async {
    if (_chatService == null || !_chatService!.isConnected) return;

    final sessionKey = state.currentSessionKey;
    if (sessionKey == null) return;

    // Optimistic UI: add user message immediately
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      content: text,
      timestamp: DateTime.now(),
      attachments: images,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isAgentRunning: true,
      streamingContent: '',
      error: null,
    );

    try {
      final res = await _chatService!.sendChatMessage(
        sessionKey: sessionKey,
        message: text,
        idempotencyKey: _uuid.v4(),
        attachments: images?.map((a) => a.toJson()).toList(),
      );
      final ok = res['ok'] as bool? ?? false;
      if (!ok) {
        final errorMsg =
            res['error']?['message'] as String? ?? 'Failed to send message';
        state = state.copyWith(
          isAgentRunning: false,
          error: errorMsg,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isAgentRunning: false,
        error: e.toString(),
      );
    }
  }

  /// Abort the current agent response.
  Future<void> abortChat() async {
    final sessionKey = state.currentSessionKey;
    if (sessionKey == null) return;
    try {
      await _chatService?.abortChat(sessionKey: sessionKey);
    } catch (_) {}
  }

  /// Switch to a different session and reload history.
  /// Pass null to start a new session.
  Future<void> switchSession(String? key) async {
    // Reconstruct state to allow null currentSessionKey
    state = ChatState(
      connectionState: state.connectionState,
      messages: const [],
      sessions: state.sessions,
      currentSessionKey: key,
      isAgentRunning: false,
      streamingContent: '',
    );
    if (key != null) {
      await _loadHistory();
    }
  }

  /// Load the list of available sessions.
  Future<void> loadSessions() async {
    try {
      final sessions = await _chatService?.listSessions() ?? [];
      state = state.copyWith(sessions: sessions);

      // Auto-select the first session if none selected
      if (state.currentSessionKey == null && sessions.isNotEmpty) {
        state = state.copyWith(currentSessionKey: sessions.first.key);
      }
    } catch (_) {}

    // Fallback: use default session key if still null
    if (state.currentSessionKey == null) {
      state = state.copyWith(currentSessionKey: _defaultSessionKey);
    }
  }

  Future<void> _loadInitialData() async {
    // Load sessions first to get the default session key
    await loadSessions();
    // Then load history for the selected session
    await _loadHistory();
  }

  Future<void> _loadHistory() async {
    final sessionKey = state.currentSessionKey;
    if (sessionKey == null) return;

    try {
      final res = await _chatService?.loadHistory(sessionKey: sessionKey);
      if (res == null) return;

      final ok = res['ok'] as bool? ?? false;
      if (!ok) return;

      final payload = res['payload'] as Map<String, dynamic>?;
      final messagesList = payload?['messages'] as List<dynamic>? ?? [];

      final messages = messagesList.map((m) {
        final msg = m as Map<String, dynamic>;
        return ChatMessage(
          id: msg['id'] as String? ?? '',
          role: msg['role'] as String? ?? 'assistant',
          content: msg['role'] == 'user'
              ? _cleanUserContent(_extractTextContent(msg['content']))
              : _extractTextContent(msg['content']),
          timestamp: msg['timestamp'] != null
              ? DateTime.fromMillisecondsSinceEpoch(
                  msg['timestamp'] is int
                      ? msg['timestamp'] as int
                      : int.tryParse(msg['timestamp'].toString()) ?? 0,
                )
              : DateTime.now(),
        );
      }).toList();

      final filtered = _filterHeartbeatMessages(messages);
      state = state.copyWith(messages: filtered);
    } catch (_) {}
  }

  void _listenToEvents() {
    _eventSubscription?.cancel();
    _eventSubscription = _chatService?.events.listen(_handleEvent);
  }

  void _handleEvent(Map<String, dynamic> data) {
    final event = data['event'] as String?;
    if (event != 'chat') return;

    final payload = data['payload'] as Map<String, dynamic>?;
    if (payload == null) return;

    final eventState = payload['state'] as String?;

    switch (eventState) {
      case 'delta':
        _handleDelta(payload);
        break;
      case 'final':
        _handleFinal(payload);
        break;
      case 'error':
        _handleError(payload);
        break;
      case 'aborted':
        _handleAborted();
        break;
    }
  }

  void _handleDelta(Map<String, dynamic> payload) {
    final message = payload['message'] as Map<String, dynamic>?;
    final content = message?['content'] as List<dynamic>?;
    if (content == null || content.isEmpty) return;

    final textBlock = content.firstWhere(
      (c) => (c as Map<String, dynamic>)['type'] == 'text',
      orElse: () => null,
    );
    if (textBlock == null) return;

    final text = (textBlock as Map<String, dynamic>)['text'] as String? ?? '';

    if (_isHeartbeatMessage(text, 'assistant')) return;

    // Delta events contain the full accumulated text, not incremental chunks
    state = state.copyWith(streamingContent: text);
  }

  void _handleFinal(Map<String, dynamic> payload) {
    final message = payload['message'] as Map<String, dynamic>?;

    final content = message != null
        ? _extractTextContent(message['content'])
        : state.streamingContent;

    // Skip heartbeat acknowledgement messages
    if (_isHeartbeatMessage(content, 'assistant')) {
      state = state.copyWith(
        isAgentRunning: false,
        streamingContent: '',
      );
      return;
    }

    // Skip adding empty assistant messages (e.g., silent replies)
    if (content.isEmpty) {
      state = state.copyWith(
        isAgentRunning: false,
        streamingContent: '',
      );
      return;
    }

    final assistantMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'assistant',
      content: content,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, assistantMessage],
      isAgentRunning: false,
      streamingContent: '',
    );
  }

  void _handleError(Map<String, dynamic> payload) {
    final error = payload['errorMessage'] as String? ?? 'Unknown error';
    state = state.copyWith(
      isAgentRunning: false,
      streamingContent: '',
      error: error,
    );
  }

  void _handleAborted() {
    // If there was any streamed content before abort, save it as a partial message
    if (state.streamingContent.isNotEmpty) {
      final partialMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'assistant',
        content: state.streamingContent,
        timestamp: DateTime.now(),
        stopReason: 'aborted',
      );
      state = state.copyWith(
        messages: [...state.messages, partialMessage],
        isAgentRunning: false,
        streamingContent: '',
      );
    } else {
      state = state.copyWith(
        isAgentRunning: false,
        streamingContent: '',
      );
    }
  }

  // ── Heartbeat filtering ──────────────────────────────────────────

  static final _timestampEnvelope = RegExp(r'^\[[^\]]*\d{4}-\d{2}-\d{2}[^\]]*\]\s*');

  static String _stripTimestampEnvelope(String text) {
    return text.replaceFirst(_timestampEnvelope, '');
  }

  static bool _isHeartbeatMessage(String content, String role) {
    final trimmed = content.trim();
    final lower = trimmed.toLowerCase();

    if (role == 'user') {
      final stripped = _stripTimestampEnvelope(lower);
      if (stripped.startsWith('read heartbeat.md')) return true;
      if (stripped.contains('heartbeat.md') &&
          stripped.contains('heartbeat_ok') &&
          stripped.length < 500) {
        return true;
      }
      return false;
    }

    if (role == 'assistant') {
      final cleaned = trimmed
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .replaceAll(RegExp(r'[*`~_]+'), '')
          .trim();
      if (cleaned == 'HEARTBEAT_OK') return true;
      if (cleaned.length < 30 &&
          (cleaned.startsWith('HEARTBEAT_OK') ||
              cleaned.endsWith('HEARTBEAT_OK'))) {
        final remainder = cleaned
            .replaceAll('HEARTBEAT_OK', '')
            .replaceAll(RegExp(r'[\s.!,;:]+'), '');
        if (remainder.length < 10) return true;
      }
      return false;
    }

    return false;
  }

  static List<ChatMessage> _filterHeartbeatMessages(List<ChatMessage> messages) {
    final skip = <int>{};
    for (var i = 0; i < messages.length; i++) {
      if (skip.contains(i)) continue;
      if (!_isHeartbeatMessage(messages[i].content, messages[i].role)) continue;
      skip.add(i);
      // User heartbeat → skip the following assistant response too
      if (messages[i].role == 'user' &&
          i + 1 < messages.length &&
          messages[i + 1].role == 'assistant') {
        skip.add(i + 1);
      }
      // Assistant heartbeat ack → skip the preceding user prompt if heartbeat
      if (messages[i].role == 'assistant' &&
          i > 0 &&
          !skip.contains(i - 1)) {
        if (_isHeartbeatMessage(messages[i - 1].content, 'user')) {
          skip.add(i - 1);
        }
      }
    }
    if (skip.isEmpty) return messages;
    return [
      for (var i = 0; i < messages.length; i++)
        if (!skip.contains(i)) messages[i],
    ];
  }

  // ── User content cleaning ─────────────────────────────────────────

  static final _inboundMetaBlock = RegExp(
    r'^[^\n]+ \(untrusted[^\n]*\):\n```(?:json)?\n[\s\S]*?\n```\s*',
  );
  static final _envelopePrefix = RegExp(
    r'^\[([^\]]+)\]\s*',
  );
  static final _messageIdLine = RegExp(
    r'^\s*\[message_id:\s*[^\]]+\]\s*$',
    multiLine: true,
  );

  static String _cleanUserContent(String text) {
    var result = text;
    // Strip inbound metadata blocks
    while (_inboundMetaBlock.hasMatch(result)) {
      result = result.replaceFirst(_inboundMetaBlock, '');
    }
    // Strip timestamp envelope
    final match = _envelopePrefix.firstMatch(result);
    if (match != null) {
      final header = match.group(1) ?? '';
      if (RegExp(r'\d{4}-\d{2}-\d{2}').hasMatch(header)) {
        result = result.substring(match.end);
      }
    }
    // Strip message_id hints
    result = result.replaceAll(_messageIdLine, '');
    return result.trim();
  }

  /// Extract text from a content array (list of content blocks) or plain string.
  String _extractTextContent(dynamic content) {
    if (content is String) return content;
    if (content is List) {
      final buffer = StringBuffer();
      for (final block in content) {
        if (block is Map<String, dynamic> && block['type'] == 'text') {
          buffer.write(block['text'] as String? ?? '');
        }
      }
      return buffer.toString();
    }
    return '';
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    _chatService?.dispose();
    super.dispose();
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ref);
});
