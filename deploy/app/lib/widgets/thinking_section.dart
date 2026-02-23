import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ThinkingSection extends StatefulWidget {
  final String content;
  final bool isStreaming;

  const ThinkingSection({
    super.key,
    required this.content,
    this.isStreaming = false,
  });

  @override
  State<ThinkingSection> createState() => _ThinkingSectionState();
}

class _ThinkingSectionState extends State<ThinkingSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: AppColors.textTertiary, width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Thinking',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  if (widget.isStreaming) ...[
                    const SizedBox(width: 6),
                    const SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 8, 4),
              child: Text(
                widget.content,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
