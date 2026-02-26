import 'package:flutter/material.dart';

import 'package:clawbox/l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

class RemoteViewTile extends StatelessWidget {
  final bool isReady;
  final VoidCallback onTap;

  const RemoteViewTile({super.key, required this.isReady, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GlassCard.solid(
      padding: const EdgeInsets.all(16),
      onTap: isReady ? onTap : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.desktop_windows,
            color: isReady ? AppColors.textSecondary : AppColors.textTertiary,
            size: 24,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.remoteView,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isReady ? null : AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.remoteViewDescription,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
