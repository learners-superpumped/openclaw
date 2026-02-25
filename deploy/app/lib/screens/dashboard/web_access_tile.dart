import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:clawbox/l10n/app_localizations.dart';
import '../../models/instance.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

class WebAccessTile extends StatelessWidget {
  final ManagerStatus manager;

  const WebAccessTile({super.key, required this.manager});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final gatewayReady = manager.gatewayReady ?? false;

    return GlassCard.solid(
      padding: const EdgeInsets.all(16),
      onTap: gatewayReady
          ? () {
              final url = manager.gatewayUrl;
              final token = manager.gatewayToken;
              if (url != null) {
                final webUrl = token != null ? '$url#token=$token' : url;
                launchUrl(
                  Uri.parse(webUrl),
                  mode: LaunchMode.externalApplication,
                );
              }
            }
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.language,
            color: gatewayReady
                ? AppColors.textSecondary
                : AppColors.textTertiary,
            size: 24,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.webAccess,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: gatewayReady ? null : AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 4),
          if (!gatewayReady) ...[
            Row(
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.webAccessPreparing,
                    style: TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l10n.webAccessPreparingHint,
              style: TextStyle(color: AppColors.textTertiary, fontSize: 10),
            ),
          ] else
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.accentGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    manager.gatewayUrl ?? '',
                    style: TextStyle(color: AppColors.accent, fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
