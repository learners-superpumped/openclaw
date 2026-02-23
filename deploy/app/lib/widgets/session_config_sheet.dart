import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/chat_provider.dart';
import '../theme/app_theme.dart';
import 'package:clawbox/l10n/app_localizations.dart';

class SessionConfigSheet extends ConsumerStatefulWidget {
  const SessionConfigSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const SessionConfigSheet(),
    );
  }

  @override
  ConsumerState<SessionConfigSheet> createState() => _SessionConfigSheetState();
}

class _SessionConfigSheetState extends ConsumerState<SessionConfigSheet> {
  late TextEditingController _labelController;
  String _reasoningLevel = 'medium';

  @override
  void initState() {
    super.initState();
    final chatState = ref.read(chatProvider);
    _labelController = TextEditingController(
      text: chatState.currentSessionName ?? '',
    );
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textTertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                l10n.sessionSettings,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.border),

            // Label
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                l10n.editSessionLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _labelController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (value) {
                  ref.read(chatProvider.notifier).patchSession(label: value);
                },
              ),
            ),

            // Reasoning level
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                l10n.reasoningLevel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'low',
                    label: Text(l10n.reasoningLow),
                  ),
                  ButtonSegment(
                    value: 'medium',
                    label: Text(l10n.reasoningMedium),
                  ),
                  ButtonSegment(
                    value: 'high',
                    label: Text(l10n.reasoningHigh),
                  ),
                ],
                selected: {_reasoningLevel},
                onSelectionChanged: (selected) {
                  setState(() => _reasoningLevel = selected.first);
                  ref.read(chatProvider.notifier).patchSession(
                    reasoningLevel: selected.first,
                  );
                },
                style: SegmentedButton.styleFrom(
                  backgroundColor: AppColors.surfaceLight,
                  foregroundColor: AppColors.textSecondary,
                  selectedForegroundColor: AppColors.accent,
                  selectedBackgroundColor:
                      AppColors.accent.withValues(alpha: 0.15),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.border),

            // Delete session
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmDeleteSession(context),
                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                  label: Text(
                    l10n.deleteSession,
                    style: const TextStyle(color: AppColors.error),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteSession(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sessionKey = ref.read(chatProvider).currentSessionKey;
    if (sessionKey == null) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(l10n.deleteSession),
        content: Text(l10n.deleteSessionConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
              ref.read(chatProvider.notifier).deleteSession(sessionKey);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
