import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../models/chat_message.dart';
import '../theme/app_theme.dart';
import '../utils/text_direction_utils.dart';
import 'package:clawbox/l10n/app_localizations.dart';
import 'thinking_section.dart';
import 'tool_card_widget.dart';
import 'typing_indicator.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isFirstInGroup;
  final bool isLastInGroup;

  static const _largeTextThreshold = 15000;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.isFirstInGroup = true,
    this.isLastInGroup = true,
  });

  bool get _isUser => message.role == 'user';

  @override
  Widget build(BuildContext context) {
    if (_isUser) {
      return _buildUserMessage(context);
    }
    return _buildAssistantMessage(context);
  }

  Widget _buildUserMessage(BuildContext context) {
    final textDir = detectTextDirection(message.content);

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: Radius.circular(isFirstInGroup ? 18 : 6),
              bottomLeft: const Radius.circular(18),
              bottomRight: Radius.circular(isLastInGroup ? 4 : 6),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.attachments != null &&
                  message.attachments!.isNotEmpty)
                _buildAttachments(context),
              if (message.content.isNotEmpty)
                Directionality(
                  textDirection: textDir,
                  child: Text(
                    message.content,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssistantMessage(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isLastInGroup)
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.accent,
                size: 16,
              ),
            )
          else
            const SizedBox(width: 28),
          const SizedBox(width: 8),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.85,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isFirstInGroup ? 18 : 6),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isLastInGroup ? 4 : 6),
                    bottomRight: const Radius.circular(18),
                  ),
                ),
                child: message.isStreaming && message.content.isEmpty && message.thinkingContent == null && message.toolCards == null
                    ? const TypingIndicator()
                    : _buildMarkdownContent(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkdownContent(BuildContext context) {
    final content = message.content;
    final thinking = message.thinkingContent;
    final toolCards = message.toolCards;
    final isLargeText = content.length > _largeTextThreshold;
    final textDir = detectTextDirection(content);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Thinking section
        if (thinking != null && thinking.isNotEmpty)
          ThinkingSection(
            content: thinking,
            isStreaming: message.isStreaming,
          ),

        // Tool cards
        if (toolCards != null && toolCards.isNotEmpty)
          ...toolCards.map((tc) => ToolCardWidget(data: tc)),

        // Content
        if (content.isNotEmpty) ...[
          if (isLargeText) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                l10n.largeMessagePlaintext,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.warning,
                  fontSize: 10,
                ),
              ),
            ),
            Directionality(
              textDirection: textDir,
              child: SelectableText(
                content,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ] else
            Directionality(
              textDirection: textDir,
              child: MarkdownBody(
                data: content,
                selectable: true,
                styleSheet: _markdownStyleSheet(context),
              ),
            ),
        ],

        // Action bar (copy button) — only after streaming completes
        if (!message.isStreaming && content.isNotEmpty) ...[
          const SizedBox(height: 4),
          _buildActionBar(context),
        ],

        // Streaming indicator
        if (message.isStreaming) ...[
          const SizedBox(height: 4),
          const TypingIndicator(),
        ],
      ],
    );
  }

  Widget _buildActionBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            // Copy full content including thinking if present
            final buffer = StringBuffer();
            if (message.thinkingContent != null) {
              buffer.writeln('> *Thinking:*');
              buffer.writeln('> ${message.thinkingContent}');
              buffer.writeln();
            }
            buffer.write(message.content);
            Clipboard.setData(ClipboardData(text: buffer.toString()));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.copiedToClipboard),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.copy_rounded,
                  size: 13,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Copy',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  MarkdownStyleSheet _markdownStyleSheet(BuildContext context) {
    return MarkdownStyleSheet(
      p: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
      h1: Theme.of(
        context,
      ).textTheme.displayMedium?.copyWith(color: AppColors.textPrimary),
      h2: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
      h3: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(color: AppColors.textPrimary),
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
      blockquotePadding: const EdgeInsets.only(
        left: 12,
        top: 4,
        bottom: 4,
      ),
      a: const TextStyle(color: AppColors.accent),
      listBullet: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
      strong: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      em: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: AppColors.textPrimary,
        fontStyle: FontStyle.italic,
      ),
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
    BuildContext context,
    ChatAttachment attachment,
  ) {
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
}
