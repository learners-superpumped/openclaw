import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../models/chat_message.dart';
import '../theme/app_theme.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({super.key, required this.message});

  bool get _isUser => message.role == 'user';

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Column(
          crossAxisAlignment:
              _isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            _buildBubble(context),
            const SizedBox(height: 4),
            _buildTimestamp(context),
            if (!_isUser && message.usage != null && message.stopReason != null)
              _buildUsageInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBubble(BuildContext context) {
    if (_isUser) {
      return _buildUserBubble(context);
    }
    return _buildAssistantBubble(context);
  }

  Widget _buildUserBubble(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.15),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.3),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.attachments != null && message.attachments!.isNotEmpty)
            _buildAttachments(context),
          if (message.content.isNotEmpty)
            Text(
              message.content,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.textPrimary),
            ),
        ],
      ),
    );
  }

  Widget _buildAssistantBubble(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border.all(color: AppColors.border),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: message.isStreaming && message.content.isEmpty
          ? const _StreamingCursor()
          : _buildMarkdownContent(context),
    );
  }

  Widget _buildMarkdownContent(BuildContext context) {
    final content = message.content;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MarkdownBody(
          data: content,
          selectable: true,
          styleSheet: MarkdownStyleSheet(
            p: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.textPrimary),
            h1: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
            h2: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                ),
            h3: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
            code: TextStyle(
              color: AppColors.accent,
              backgroundColor: AppColors.surface,
              fontFamily: 'monospace',
              fontSize: 13,
            ),
            codeblockDecoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            codeblockPadding: const EdgeInsets.all(12),
            blockquoteDecoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: AppColors.accent.withValues(alpha: 0.5),
                  width: 3,
                ),
              ),
            ),
            blockquotePadding:
                const EdgeInsets.only(left: 12, top: 4, bottom: 4),
            a: const TextStyle(color: AppColors.accent),
            listBullet: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.textPrimary),
            strong: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
            em: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ),
        if (message.isStreaming) ...[
          const SizedBox(height: 2),
          const _StreamingCursor(),
        ],
      ],
    );
  }

  Widget _buildAttachments(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: message.attachments!
            .where((a) => a.type == 'image')
            .map((attachment) => _buildAttachmentImage(context, attachment))
            .toList(),
      ),
    );
  }

  Widget _buildAttachmentImage(
      BuildContext context, ChatAttachment attachment) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.memory(
        base64Decode(attachment.content),
        width: 200,
        height: 150,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 200,
            height: 150,
            color: AppColors.surface,
            child: const Icon(
              Icons.broken_image_rounded,
              color: AppColors.textTertiary,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimestamp(BuildContext context) {
    final time = message.timestamp;
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        '$hour:$minute',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textTertiary,
              fontSize: 11,
            ),
      ),
    );
  }

  Widget _buildUsageInfo(BuildContext context) {
    final usage = message.usage!;
    return Padding(
      padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
      child: Text(
        '${usage.inputTokens} in / ${usage.outputTokens} out tokens',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textTertiary,
              fontSize: 10,
            ),
      ),
    );
  }
}

class _StreamingCursor extends StatefulWidget {
  const _StreamingCursor();

  @override
  State<_StreamingCursor> createState() => _StreamingCursorState();
}

class _StreamingCursorState extends State<_StreamingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Opacity(
          opacity: _controller.value,
          child: const Text(
            '\u258d',
            style: TextStyle(
              color: AppColors.accent,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        );
      },
    );
  }
}
