import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/chat_message.dart';
import '../models/chat_session.dart';
import '../services/chat_service.dart';
import '../utils/message_extract.dart';
import 'api_provider.dart';

const _uuid = Uuid();
const _toolStreamLimit = 50;

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
  final String? streamingThinking;
  final Map<String, ToolCardData> toolStreamById;
  final List<String> toolStreamOrder;
  final List<QueuedMessage> messageQueue;
  final bool isCompacting;
  final int? totalMessageCount;
  final String? error;

  const ChatState({
    this.connectionState = ChatConnectionState.disconnected,
    this.messages = const [],
    this.sessions = const [],
    this.currentSessionKey,
    this.isAgentRunning = false,
    this.streamingContent = '',
    this.streamingThinking,
    this.toolStreamById = const {},
    this.toolStreamOrder = const [],
    this.messageQueue = const [],
    this.isCompacting = false,
    this.totalMessageCount,
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
    if (streamingContent.isEmpty &&
        streamingThinking == null &&
        toolStreamById.isEmpty &&
        !isAgentRunning) {
      return null;
    }

    // Collect active tool cards from stream
    List<ToolCardData>? activeToolCards;
    if (toolStreamById.isNotEmpty) {
      activeToolCards = toolStreamOrder
          .where((id) => toolStreamById.containsKey(id))
          .map((id) => toolStreamById[id]!)
          .toList();
    }

    return ChatMessage(
      id: 'streaming',
      role: 'assistant',
      content: streamingContent,
      timestamp: DateTime.now(),
      isStreaming: true,
      thinkingContent: streamingThinking,
      toolCards: activeToolCards,
    );
  }

  ChatState copyWith({
    ChatConnectionState? connectionState,
    List<ChatMessage>? messages,
    List<ChatSession>? sessions,
    String? currentSessionKey,
    bool? isAgentRunning,
    String? streamingContent,
    String? streamingThinking,
    Map<String, ToolCardData>? toolStreamById,
    List<String>? toolStreamOrder,
    List<QueuedMessage>? messageQueue,
    bool? isCompacting,
    int? totalMessageCount,
    String? error,
  }) {
    return ChatState(
      connectionState: connectionState ?? this.connectionState,
      messages: messages ?? this.messages,
      sessions: sessions ?? this.sessions,
      currentSessionKey: currentSessionKey ?? this.currentSessionKey,
      isAgentRunning: isAgentRunning ?? this.isAgentRunning,
      streamingContent: streamingContent ?? this.streamingContent,
      streamingThinking: streamingThinking ?? this.streamingThinking,
      toolStreamById: toolStreamById ?? this.toolStreamById,
      toolStreamOrder: toolStreamOrder ?? this.toolStreamOrder,
      messageQueue: messageQueue ?? this.messageQueue,
      isCompacting: isCompacting ?? this.isCompacting,
      totalMessageCount: totalMessageCount ?? this.totalMessageCount,
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
  /// If agent is running, queue the message instead.
  /// Special commands (/stop, /abort, /new, /reset) are always handled immediately.
  Future<void> sendMessage(
    String text, {
    List<ChatAttachment>? images,
  }) async {
    if (_chatService == null || !_chatService!.isConnected) return;

    final sessionKey = state.currentSessionKey;
    if (sessionKey == null) return;

    // Special commands — always execute immediately, never queue
    final trimmed = text.trim();
    if (trimmed == '/stop' || trimmed == '/abort') {
      await abortChat();
      return;
    }
    if (trimmed == '/new' || trimmed == '/reset') {
      await switchSession(null);
      return;
    }

    // Queue if agent is running
    if (state.isAgentRunning) {
      final queued = QueuedMessage(
        id: _uuid.v4(),
        text: text,
        attachments: images,
        queuedAt: DateTime.now(),
      );
      state = state.copyWith(
        messageQueue: [...state.messageQueue, queued],
      );
      return;
    }

    await _sendMessageDirect(text, images: images);
  }

  Future<void> _sendMessageDirect(
    String text, {
    List<ChatAttachment>? images,
  }) async {
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
      streamingThinking: null,
      toolStreamById: const {},
      toolStreamOrder: const [],
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

  /// Remove a message from the queue.
  void removeFromQueue(String id) {
    state = state.copyWith(
      messageQueue: state.messageQueue.where((m) => m.id != id).toList(),
    );
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

  /// Patch current session settings.
  Future<void> patchSession({
    String? label,
    String? reasoningLevel,
    String? thinkingLevel,
    String? verboseLevel,
  }) async {
    final sessionKey = state.currentSessionKey;
    if (sessionKey == null) return;
    try {
      await _chatService?.patchSession(
        sessionKey: sessionKey,
        label: label,
        reasoningLevel: reasoningLevel,
        thinkingLevel: thinkingLevel,
        verboseLevel: verboseLevel,
      );
      // Refresh sessions to reflect changes
      await loadSessions();
    } catch (_) {}
  }

  /// Delete a session.
  Future<void> deleteSession(String sessionKey) async {
    try {
      await _chatService?.deleteSession(sessionKey: sessionKey);
      // If we deleted the current session, switch away
      if (state.currentSessionKey == sessionKey) {
        await loadSessions();
        final remaining = state.sessions
            .where((s) => s.key != sessionKey)
            .toList();
        if (remaining.isNotEmpty) {
          await switchSession(remaining.first.key);
        } else {
          await switchSession(null);
        }
      } else {
        await loadSessions();
      }
    } catch (_) {}
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
      final total = payload?['total'] as int?;

      final messages = messagesList.where((m) {
        final role = (m as Map<String, dynamic>)['role'] as String?;
        return role == 'user' || role == 'assistant';
      }).map((m) {
        final msg = m as Map<String, dynamic>;
        final extracted = extractMessageContent(msg['content']);

        final rawText = msg['role'] == 'user'
            ? _cleanUserContent(extracted.text)
            : extracted.text;

        return ChatMessage(
          id: msg['id'] as String? ?? '',
          role: msg['role'] as String? ?? 'assistant',
          content: rawText,
          timestamp: msg['timestamp'] != null
              ? DateTime.fromMillisecondsSinceEpoch(
                  msg['timestamp'] is int
                      ? msg['timestamp'] as int
                      : int.tryParse(msg['timestamp'].toString()) ?? 0,
                )
              : DateTime.now(),
          thinkingContent: msg['role'] == 'assistant' ? extracted.thinking : null,
          toolCards: msg['role'] == 'assistant' && extracted.toolCards.isNotEmpty
              ? extracted.toolCards
              : null,
        );
      }).toList();

      final filtered = _filterHeartbeatMessages(messages);
      state = state.copyWith(
        messages: filtered,
        totalMessageCount: total,
      );
    } catch (_) {}
  }

  void _listenToEvents() {
    _eventSubscription?.cancel();
    _eventSubscription = _chatService?.events.listen(_handleEvent);
  }

  void _handleEvent(Map<String, dynamic> data) {
    final event = data['event'] as String?;

    if (event == 'chat') {
      _handleChatEvent(data);
    } else if (event == 'agent') {
      _handleAgentEvent(data);
    }
  }

  void _handleChatEvent(Map<String, dynamic> data) {
    final payload = data['payload'] as Map<String, dynamic>?;
    if (payload == null) return;

    final eventState = payload['state'] as String?;

    // Detect compaction
    if (eventState == 'compacting') {
      state = state.copyWith(isCompacting: true);
      return;
    }
    if (eventState == 'compacted') {
      state = state.copyWith(isCompacting: false);
      return;
    }

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

  void _handleAgentEvent(Map<String, dynamic> data) {
    final payload = data['payload'] as Map<String, dynamic>?;
    if (payload == null) return;

    final stream = payload['stream'] as String?;
    if (stream != 'tool') return;

    final phase = payload['phase'] as String?;
    final toolCallId = payload['toolCallId'] as String? ?? payload['id'] as String? ?? '';

    switch (phase) {
      case 'start':
        if (state.toolStreamOrder.length >= _toolStreamLimit) return;
        final name = payload['name'] as String? ?? 'tool';
        final args = payload['args'];
        final newMap = Map<String, ToolCardData>.from(state.toolStreamById);
        newMap[toolCallId] = ToolCardData(
          kind: 'call',
          name: name,
          args: args,
          toolCallId: toolCallId,
          isStreaming: true,
        );
        state = state.copyWith(
          toolStreamById: newMap,
          toolStreamOrder: [...state.toolStreamOrder, toolCallId],
        );
        break;

      case 'update':
        if (!state.toolStreamById.containsKey(toolCallId)) return;
        final output = payload['output'] as String? ?? '';
        final newMap = Map<String, ToolCardData>.from(state.toolStreamById);
        newMap[toolCallId] = newMap[toolCallId]!.copyWith(output: output);
        state = state.copyWith(toolStreamById: newMap);
        break;

      case 'result':
        if (!state.toolStreamById.containsKey(toolCallId)) return;
        final output = payload['output'] as String? ?? payload['result'] as String? ?? '';
        final newMap = Map<String, ToolCardData>.from(state.toolStreamById);
        newMap[toolCallId] = newMap[toolCallId]!.copyWith(
          kind: 'result',
          output: output,
          isStreaming: false,
        );
        state = state.copyWith(toolStreamById: newMap);
        break;
    }
  }

  void _handleDelta(Map<String, dynamic> payload) {
    final message = payload['message'] as Map<String, dynamic>?;
    final content = message?['content'];

    if (content is List) {
      String? textAccum;
      String? thinkingAccum;

      for (final block in content) {
        if (block is! Map<String, dynamic>) continue;
        final type = block['type'] as String?;
        if (type == 'text') {
          textAccum = block['text'] as String? ?? '';
        } else if (type == 'thinking') {
          thinkingAccum = block['thinking'] as String? ??
              block['text'] as String? ?? '';
        }
      }

      if (textAccum != null && _isHeartbeatMessage(textAccum, 'assistant')) {
        return;
      }

      state = state.copyWith(
        streamingContent: textAccum ?? state.streamingContent,
        streamingThinking: thinkingAccum ?? state.streamingThinking,
      );
      return;
    }

    // Fallback: content is string or null
    if (content == null && message == null) return;
    final text = content is String
        ? content
        : (message?['content'] is String ? message!['content'] as String : null);
    if (text == null) return;

    if (_isHeartbeatMessage(text, 'assistant')) return;

    state = state.copyWith(streamingContent: text);
  }

  void _handleFinal(Map<String, dynamic> payload) {
    final message = payload['message'] as Map<String, dynamic>?;

    String content;
    String? thinking;
    List<ToolCardData>? toolCards;

    if (message != null) {
      final extracted = extractMessageContent(message['content']);
      content = extracted.text;
      thinking = extracted.thinking ?? state.streamingThinking;
      toolCards = extracted.toolCards.isNotEmpty
          ? extracted.toolCards
          : _collectToolStreamCards();
    } else {
      content = state.streamingContent;
      thinking = state.streamingThinking;
      toolCards = _collectToolStreamCards();
    }

    // Skip heartbeat acknowledgement messages
    if (_isHeartbeatMessage(content, 'assistant')) {
      _resetStreamingState();
      return;
    }

    // Skip adding empty assistant messages (e.g., silent replies)
    if (content.isEmpty && thinking == null && (toolCards == null || toolCards.isEmpty)) {
      _resetStreamingState();
      return;
    }

    final assistantMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'assistant',
      content: content,
      timestamp: DateTime.now(),
      thinkingContent: thinking,
      toolCards: toolCards != null && toolCards.isNotEmpty ? toolCards : null,
    );

    state = state.copyWith(
      messages: [...state.messages, assistantMessage],
      isAgentRunning: false,
      streamingContent: '',
      streamingThinking: null,
      toolStreamById: const {},
      toolStreamOrder: const [],
    );

    // Flush message queue
    _flushQueue();
  }

  List<ToolCardData>? _collectToolStreamCards() {
    if (state.toolStreamOrder.isEmpty) return null;
    return state.toolStreamOrder
        .where((id) => state.toolStreamById.containsKey(id))
        .map((id) => state.toolStreamById[id]!)
        .toList();
  }

  void _resetStreamingState() {
    state = state.copyWith(
      isAgentRunning: false,
      streamingContent: '',
      streamingThinking: null,
      toolStreamById: const {},
      toolStreamOrder: const [],
    );
    _flushQueue();
  }

  void _handleError(Map<String, dynamic> payload) {
    final error = payload['errorMessage'] as String? ?? 'Unknown error';
    state = state.copyWith(
      isAgentRunning: false,
      streamingContent: '',
      streamingThinking: null,
      toolStreamById: const {},
      toolStreamOrder: const [],
      error: error,
    );
    _flushQueue();
  }

  void _handleAborted() {
    // If there was any streamed content before abort, save it as a partial message
    if (state.streamingContent.isNotEmpty ||
        state.streamingThinking != null) {
      final toolCards = _collectToolStreamCards();
      final partialMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'assistant',
        content: state.streamingContent,
        timestamp: DateTime.now(),
        stopReason: 'aborted',
        thinkingContent: state.streamingThinking,
        toolCards: toolCards != null && toolCards.isNotEmpty ? toolCards : null,
      );
      state = state.copyWith(
        messages: [...state.messages, partialMessage],
        isAgentRunning: false,
        streamingContent: '',
        streamingThinking: null,
        toolStreamById: const {},
        toolStreamOrder: const [],
      );
    } else {
      state = state.copyWith(
        isAgentRunning: false,
        streamingContent: '',
        streamingThinking: null,
        toolStreamById: const {},
        toolStreamOrder: const [],
      );
    }
    _flushQueue();
  }

  /// Flush the message queue: send next queued message if available.
  void _flushQueue() {
    if (state.messageQueue.isEmpty) return;
    final next = state.messageQueue.first;
    state = state.copyWith(
      messageQueue: state.messageQueue.sublist(1),
    );
    _sendMessageDirect(next.text, images: next.attachments);
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
