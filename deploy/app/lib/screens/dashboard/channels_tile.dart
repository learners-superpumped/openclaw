import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:clawbox/l10n/app_localizations.dart';
import '../../models/channel.dart';
import '../../providers/channel_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

class ChannelsTile extends StatelessWidget {
  final ChannelState channelState;
  final ChannelInfo? telegramInfo;
  final ChannelInfo? whatsappInfo;
  final ChannelInfo? discordInfo;
  final bool isReady;
  final VoidCallback onTap;

  const ChannelsTile({
    super.key,
    required this.channelState,
    this.telegramInfo,
    this.whatsappInfo,
    this.discordInfo,
    required this.isReady,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GlassCard.solid(
      padding: const EdgeInsets.all(16),
      onTap: isReady ? onTap : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.channels.toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              if (channelState.totalPending > 0)
                _PendingBadge(count: channelState.totalPending),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ChannelIcon(
                icon: Icons.telegram,
                color: const Color(0xFF26A5E4),
                isConnected: telegramInfo?.isConnected ?? false,
              ),
              const SizedBox(width: 8),
              // TODO: temporarily hidden – WhatsApp
              // _ChannelIcon(
              //   iconData: FontAwesomeIcons.whatsapp,
              //   color: const Color(0xFF25D366),
              //   isConnected: whatsappInfo?.isConnected ?? false,
              // ),
              // const SizedBox(width: 8),
              // TODO: temporarily hidden – Discord
              // _ChannelIcon(
              //   iconData: FontAwesomeIcons.discord,
              //   color: const Color(0xFF5865F2),
              //   isConnected: discordInfo?.isConnected ?? false,
              // ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.channelsSummary(_connectedCount()),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  int _connectedCount() {
    int count = 0;
    if (telegramInfo?.isConnected ?? false) count++;
    // TODO: temporarily hidden – WhatsApp
    // if (whatsappInfo?.isConnected ?? false) count++;
    // TODO: temporarily hidden – Discord
    // if (discordInfo?.isConnected ?? false) count++;
    return count;
  }
}

// ─── Channel Icon ──────────────────────────────────────────────────────────

class _ChannelIcon extends StatelessWidget {
  final IconData? icon;
  final IconData? iconData;
  final Color color;
  final bool isConnected;

  const _ChannelIcon({
    this.icon,
    this.iconData,
    required this.color,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isConnected ? color : AppColors.textTertiary;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: effectiveColor.withValues(alpha: isConnected ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: iconData != null
                ? FaIcon(
                    iconData!,
                    color: effectiveColor.withValues(
                      alpha: isConnected ? 1.0 : 0.5,
                    ),
                    size: 15,
                  )
                : Icon(
                    icon,
                    color: effectiveColor.withValues(
                      alpha: isConnected ? 1.0 : 0.5,
                    ),
                    size: 16,
                  ),
          ),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isConnected
                  ? AppColors.accentGreen
                  : AppColors.textTertiary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.background, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Pending Badge ─────────────────────────────────────────────────────────

class _PendingBadge extends StatelessWidget {
  final int count;
  const _PendingBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$count',
          style: const TextStyle(
            color: AppColors.accent,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
