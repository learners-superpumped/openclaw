import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:clawbox/l10n/app_localizations.dart';
import '../models/channel.dart';
import '../providers/channel_provider.dart';
import '../theme/app_theme.dart';

class ChannelsScreen extends ConsumerStatefulWidget {
  const ChannelsScreen({super.key});

  @override
  ConsumerState<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends ConsumerState<ChannelsScreen> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(channelProvider.notifier).loadAll());
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => ref.read(channelProvider.notifier).loadAll(),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final channelState = ref.watch(channelProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.channels)),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(channelProvider.notifier).loadAll(force: true),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _ChannelTile(
              icon: Icons.telegram,
              iconColor: const Color(0xFF26A5E4),
              name: 'Telegram',
              info: channelState.channels[ChannelType.telegram],
              isLoading:
                  channelState.isLoading &&
                  !channelState.channels.containsKey(ChannelType.telegram),
              onTap: () => context.push('/dashboard/channels/telegram'),
            ),
            const SizedBox(height: 12),
            // TODO: temporarily hidden – WhatsApp
            // _ChannelTile(
            //   iconData: FontAwesomeIcons.whatsapp,
            //   iconColor: const Color(0xFF25D366),
            //   name: 'WhatsApp',
            //   info: channelState.channels[ChannelType.whatsapp],
            //   isLoading: channelState.isLoading && !channelState.channels.containsKey(ChannelType.whatsapp),
            //   onTap: () => context.push('/dashboard/channels/whatsapp'),
            // ),
            // const SizedBox(height: 12),
            // TODO: temporarily hidden – Discord
            // _ChannelTile(
            //   iconData: FontAwesomeIcons.discord,
            //   iconColor: const Color(0xFF5865F2),
            //   name: 'Discord',
            //   info: channelState.channels[ChannelType.discord],
            //   isLoading: channelState.isLoading && !channelState.channels.containsKey(ChannelType.discord),
            //   onTap: () => context.push('/dashboard/channels/discord'),
            // ),
          ],
        ),
      ),
    );
  }
}

class _ChannelTile extends StatelessWidget {
  final IconData? icon;
  final Color iconColor;
  final String name;
  final ChannelInfo? info;
  final bool isLoading;
  final VoidCallback onTap;

  const _ChannelTile({
    this.icon,
    required this.iconColor,
    required this.name,
    required this.info,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isConnected = info?.isConnected ?? false;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Icon(icon, color: iconColor, size: 24)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        if (isLoading)
                          SizedBox(
                            width: 8,
                            height: 8,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: AppColors.textTertiary,
                            ),
                          )
                        else
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: isConnected
                                  ? AppColors.accentGreen
                                  : AppColors.textTertiary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        const SizedBox(width: 5),
                        Text(
                          isLoading
                              ? l10n.statusWaiting
                              : isConnected
                              ? l10n.channelConnected
                              : l10n.channelDisconnected,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: isConnected
                                    ? AppColors.accentGreen
                                    : AppColors.textTertiary,
                              ),
                        ),
                        if (info != null && info!.subtitle != null) ...[
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              info!.subtitle!,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(fontSize: 11),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (info != null && info!.pendingPairings > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    l10n.pendingCount(info!.pendingPairings),
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textTertiary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
