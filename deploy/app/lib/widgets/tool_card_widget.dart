import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../theme/app_theme.dart';

class ToolCardWidget extends StatefulWidget {
  final ToolCardData data;

  const ToolCardWidget({super.key, required this.data});

  @override
  State<ToolCardWidget> createState() => _ToolCardWidgetState();
}

class _ToolCardWidgetState extends State<ToolCardWidget> {
  bool _expanded = false;

  static const _toolInlineThreshold = 80;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final icon = _getToolIcon(data.name);
    final isComplete = !data.isStreaming && data.kind == 'result';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: icon + name + status
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.textTertiary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  data.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (data.isStreaming)
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: AppColors.accent,
                  ),
                )
              else if (isComplete)
                const Icon(
                  Icons.check_circle_rounded,
                  size: 14,
                  color: AppColors.accentGreen,
                ),
            ],
          ),
          // Args summary
          if (data.args != null) ...[
            const SizedBox(height: 4),
            Text(
              _formatArgs(data.args),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          // Output
          if (data.output != null && data.output!.isNotEmpty) ...[
            const SizedBox(height: 4),
            if (data.output!.length <= _toolInlineThreshold)
              Text(
                data.output!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            else ...[
              InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Row(
                  children: [
                    Icon(
                      _expanded ? Icons.unfold_less : Icons.unfold_more,
                      size: 12,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _expanded ? 'Collapse' : 'Show output',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.accent,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (_expanded)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: SingleChildScrollView(
                      child: Text(
                        data.output!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontFamily: 'monospace',
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ],
      ),
    );
  }

  String _formatArgs(dynamic args) {
    if (args is String) return args;
    if (args is Map) {
      try {
        final encoded = jsonEncode(args);
        return encoded.length > 80 ? '${encoded.substring(0, 80)}...' : encoded;
      } catch (_) {
        return args.toString();
      }
    }
    return args?.toString() ?? '';
  }

  static IconData _getToolIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('read') || lower.contains('file')) {
      return Icons.description_outlined;
    }
    if (lower.contains('bash') ||
        lower.contains('exec') ||
        lower.contains('shell')) {
      return Icons.terminal_rounded;
    }
    if (lower.contains('search') ||
        lower.contains('grep') ||
        lower.contains('find')) {
      return Icons.search_rounded;
    }
    if (lower.contains('write') || lower.contains('edit')) {
      return Icons.edit_outlined;
    }
    if (lower.contains('web') ||
        lower.contains('fetch') ||
        lower.contains('http')) {
      return Icons.language_rounded;
    }
    if (lower.contains('list') ||
        lower.contains('ls') ||
        lower.contains('glob')) {
      return Icons.folder_outlined;
    }
    return Icons.build_outlined;
  }
}
