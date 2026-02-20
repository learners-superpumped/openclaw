import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat_session.dart';
import '../providers/chat_provider.dart';
import '../theme/app_theme.dart';
import 'package:clawbox/l10n/app_localizations.dart';

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
                      context, ref, sessions, currentSessionKey),
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
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.textPrimary),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
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
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textTertiary),
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
        trailing: session.updatedAt != null
            ? Text(
                _formatLastActivity(session.updatedAt!, AppLocalizations.of(context)!),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 11,
                    ),
              )
            : null,
        onTap: () {
          ref.read(chatProvider.notifier).switchSession(session.key);
          Navigator.of(context).pop();
        },
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
