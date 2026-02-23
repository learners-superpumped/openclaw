class ChatMessage {
  final String id;
  final String role; // 'user' | 'assistant'
  final String content;
  final DateTime timestamp;
  final List<ChatAttachment>? attachments;
  final bool isStreaming;
  final String? stopReason;
  final ChatUsage? usage;
  final String? thinkingContent;
  final List<ToolCardData>? toolCards;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.attachments,
    this.isStreaming = false,
    this.stopReason,
    this.usage,
    this.thinkingContent,
    this.toolCards,
  });

  ChatMessage copyWith({
    String? content,
    bool? isStreaming,
    String? stopReason,
    ChatUsage? usage,
    String? thinkingContent,
    List<ToolCardData>? toolCards,
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
      thinkingContent: thinkingContent ?? this.thinkingContent,
      toolCards: toolCards ?? this.toolCards,
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

class ToolCardData {
  final String kind; // 'call' | 'result'
  final String name;
  final dynamic args;
  final String? output;
  final String? toolCallId;
  final bool isStreaming;

  const ToolCardData({
    required this.kind,
    required this.name,
    this.args,
    this.output,
    this.toolCallId,
    this.isStreaming = false,
  });

  ToolCardData copyWith({
    String? kind,
    String? name,
    dynamic args,
    String? output,
    String? toolCallId,
    bool? isStreaming,
  }) {
    return ToolCardData(
      kind: kind ?? this.kind,
      name: name ?? this.name,
      args: args ?? this.args,
      output: output ?? this.output,
      toolCallId: toolCallId ?? this.toolCallId,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }
}

class QueuedMessage {
  final String id;
  final String text;
  final List<ChatAttachment>? attachments;
  final DateTime queuedAt;

  const QueuedMessage({
    required this.id,
    required this.text,
    this.attachments,
    required this.queuedAt,
  });
}
