import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/chat_provider.dart';
import '../theme/app_theme.dart';
import 'package:clawbox/l10n/app_localizations.dart';

class MessageQueueIndicator extends ConsumerWidget {
  const MessageQueueIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(chatProvider.select((s) => s.messageQueue));
    if (queue.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => _showQueueSheet(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.1),
          border: const Border(
            bottom: BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${queue.length}',
                style: const TextStyle(
                  color: AppColors.background,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              l10n.messagesInQueue,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQueueSheet(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final queue = ref.watch(chatProvider.select((s) => s.messageQueue));

            return SafeArea(
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
                      l10n.messagesInQueue,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (queue.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        l10n.messageQueued,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    )
                  else
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: queue.length,
                        itemBuilder: (context, index) {
                          final msg = queue[index];
                          return Dismissible(
                            key: Key(msg.id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) {
                              ref
                                  .read(chatProvider.notifier)
                                  .removeFromQueue(msg.id);
                            },
                            background: Container(
                              color: AppColors.error.withValues(alpha: 0.2),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16),
                              child: const Icon(
                                Icons.delete_outline,
                                color: AppColors.error,
                              ),
                            ),
                            child: ListTile(
                              title: Text(
                                msg.text,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: AppColors.textTertiary,
                                ),
                                onPressed: () {
                                  ref
                                      .read(chatProvider.notifier)
                                      .removeFromQueue(msg.id);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
