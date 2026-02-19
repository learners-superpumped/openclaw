class ChatMessage {
  final String id;
  final String role; // 'user' | 'assistant'
  final String content;
  final DateTime timestamp;
  final List<ChatAttachment>? attachments;
  final bool isStreaming;
  final String? stopReason;
  final ChatUsage? usage;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.attachments,
    this.isStreaming = false,
    this.stopReason,
    this.usage,
  });

  ChatMessage copyWith({
    String? content,
    bool? isStreaming,
    String? stopReason,
    ChatUsage? usage,
  }) {
    return ChatMessage(
      id: id,
      role: role,
      content: content ?? this.content,
      timestamp: timestamp,
      attachments: attachments,
      isStreaming: isStreaming ?? this.isStreaming,
      stopReason: stopReason ?? this.stopReason,
      usage: usage ?? this.usage,
    );
  }
}

class ChatAttachment {
  final String type; // 'image'
  final String mimeType;
  final String content; // base64
  final String? fileName;

  const ChatAttachment({
    required this.type,
    required this.mimeType,
    required this.content,
    this.fileName,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'mimeType': mimeType,
      'content': content,
      if (fileName != null) 'fileName': fileName,
    };
  }
}

class ChatUsage {
  final int inputTokens;
  final int outputTokens;

  const ChatUsage({required this.inputTokens, required this.outputTokens});

  factory ChatUsage.fromJson(Map<String, dynamic> json) {
    return ChatUsage(
      inputTokens: json['inputTokens'] as int? ?? 0,
      outputTokens: json['outputTokens'] as int? ?? 0,
    );
  }
}
