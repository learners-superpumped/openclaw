import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat_session.dart';
import '../providers/api_provider.dart';
import '../providers/chat_provider.dart';
import '../theme/app_theme.dart';
import 'package:clawbox/l10n/app_localizations.dart';
import 'session_config_sheet.dart';

class SessionDrawer extends ConsumerWidget {
  const SessionDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProvider);
    final sessions = chatState.sessions;
    final currentSessionKey = chatState.currentSessionKey;

    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, ref),
            const Divider(height: 1),
            Expanded(
              child: sessions.isEmpty
                  ? _buildEmptyState(context)
                  : _buildSessionList(
                      context,
                      ref,
                      sessions,
                      currentSessionKey,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            AppLocalizations.of(context)!.sessions,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.textPrimary),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              ref.read(chatProvider.notifier).switchSession(null);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.add),
            color: AppColors.accent,
            tooltip: AppLocalizations.of(context)!.newSession,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: const EdgeInsets.all(8),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            color: AppColors.textTertiary,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.noSessionsYet,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionList(
    BuildContext context,
    WidgetRef ref,
    List<ChatSession> sessions,
    String? currentSessionKey,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        final isActive = session.key == currentSessionKey;

        return _buildSessionTile(context, ref, session, isActive);
      },
    );
  }

  Widget _buildSessionTile(
    BuildContext context,
    WidgetRef ref,
    ChatSession session,
    bool isActive,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? AppColors.surfaceLight : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        title: Text(
          session.title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: isActive ? AppColors.accent : AppColors.textPrimary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive)
              IconButton(
                icon: const Icon(Icons.settings_outlined, size: 18),
                color: AppColors.textTertiary,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.of(context).pop();
                  SessionConfigSheet.show(context);
                },
              ),
            if (session.updatedAt != null)
              Text(
                _formatLastActivity(
                  session.updatedAt!,
                  AppLocalizations.of(context)!,
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                ),
              ),
          ],
        ),
        onTap: () {
          HapticFeedback.lightImpact();
          ref.read(analyticsProvider).logChatSessionSwitched();
          ref.read(chatProvider.notifier).switchSession(session.key);
          Navigator.of(context).pop();
        },
        onLongPress: () {
          HapticFeedback.mediumImpact();
          _showSessionContextMenu(context, ref, session);
        },
      ),
    );
  }

  void _showSessionContextMenu(
    BuildContext context,
    WidgetRef ref,
    ChatSession session,
  ) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                session.title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: AppColors.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.edit_outlined,
                color: AppColors.textSecondary,
              ),
              title: Text(l10n.editSessionLabel),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
                SessionConfigSheet.show(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.error),
              title: Text(
                l10n.deleteSession,
                style: const TextStyle(color: AppColors.error),
              ),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.of(ctx).pop();
                _confirmDeleteSession(context, ref, session);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteSession(
    BuildContext context,
    WidgetRef ref,
    ChatSession session,
  ) {
    final l10n = AppLocalizations.of(context)!;

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
              HapticFeedback.mediumImpact();
              Navigator.of(ctx).pop();
              ref.read(chatProvider.notifier).deleteSession(session.key);
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  String _formatLastActivity(DateTime lastActivity, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(lastActivity);

    if (diff.inMinutes < 1) return l10n.timeNow;
    if (diff.inMinutes < 60) return l10n.timeMinutes(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeHours(diff.inHours);
    if (diff.inDays < 7) return l10n.timeDays(diff.inDays);

    final month = lastActivity.month.toString().padLeft(2, '0');
    final day = lastActivity.day.toString().padLeft(2, '0');
    return '$month/$day';
  }
}
