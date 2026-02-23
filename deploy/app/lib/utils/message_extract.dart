import '../models/chat_message.dart';

/// Result of extracting content from a message's content field.
class ExtractedContent {
  final String text;
  final String? thinking;
  final List<ToolCardData> toolCards;

  const ExtractedContent({
    required this.text,
    this.thinking,
    this.toolCards = const [],
  });
}

/// Extract text, thinking, and tool cards from a message content field.
///
/// The content can be a plain String or a List of content blocks (OpenAI format).
ExtractedContent extractMessageContent(dynamic content) {
  if (content is String) {
    // Check for legacy <think>/<thinking> tags
    final thinking = _extractThinkingTags(content);
    final text = _stripThinkingTags(content);
    return ExtractedContent(text: text, thinking: thinking);
  }

  if (content is! List) {
    return const ExtractedContent(text: '');
  }

  final textParts = <String>[];
  String? thinking;
  final toolCards = <ToolCardData>[];

  for (final block in content) {
    if (block is! Map<String, dynamic>) continue;
    final type = block['type'] as String? ?? '';

    switch (_normalizeBlockType(type)) {
      case 'text':
        final t = block['text'] as String? ?? '';
        // Also check for embedded thinking tags in text blocks
        final tagThinking = _extractThinkingTags(t);
        if (tagThinking != null && thinking == null) {
          thinking = tagThinking;
        }
        textParts.add(_stripThinkingTags(t));
        break;

      case 'thinking':
        thinking = block['thinking'] as String? ??
            block['text'] as String? ??
            '';
        break;

      case 'tool_call':
        toolCards.add(ToolCardData(
          kind: 'call',
          name: block['name'] as String? ?? 'unknown',
          args: block['input'] ?? block['args'],
          toolCallId: block['id'] as String? ?? block['tool_call_id'] as String?,
        ));
        break;

      case 'tool_result':
        final resultContent = block['content'];
        String? output;
        if (resultContent is String) {
          output = resultContent;
        } else if (resultContent is List) {
          final parts = <String>[];
          for (final c in resultContent) {
            if (c is Map<String, dynamic> && c['type'] == 'text') {
              parts.add(c['text'] as String? ?? '');
            }
          }
          output = parts.join('\n');
        }
        toolCards.add(ToolCardData(
          kind: 'result',
          name: block['name'] as String? ?? 'tool',
          output: output,
          toolCallId: block['tool_use_id'] as String? ??
              block['tool_call_id'] as String?,
        ));
        break;
    }
  }

  return ExtractedContent(
    text: textParts.join(),
    thinking: thinking,
    toolCards: toolCards,
  );
}

/// Normalize various tool type strings to a canonical form.
String _normalizeBlockType(String type) {
  switch (type) {
    case 'text':
      return 'text';
    case 'thinking':
    case 'reasoning':
      return 'thinking';
    case 'tool_use':
    case 'tooluse':
    case 'tool_call':
    case 'toolcall':
      return 'tool_call';
    case 'tool_result':
    case 'toolresult':
      return 'tool_result';
    default:
      return type;
  }
}

// Legacy thinking tag patterns
final _thinkTagPattern = RegExp(
  r'<think(?:ing)?>([\s\S]*?)</think(?:ing)?>',
  caseSensitive: false,
);

/// Extract thinking content from legacy think/thinking tags.
String? _extractThinkingTags(String text) {
  final match = _thinkTagPattern.firstMatch(text);
  if (match == null) return null;
  final content = match.group(1)?.trim();
  return (content != null && content.isNotEmpty) ? content : null;
}

/// Strip think/thinking tags from text.
String _stripThinkingTags(String text) {
  return text.replaceAll(_thinkTagPattern, '').trim();
}
