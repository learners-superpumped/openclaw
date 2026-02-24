import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/channel.dart';
import '../models/instance.dart';
import '../models/usage.dart';
import '../providers/channel_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/instance_provider.dart';
import '../providers/usage_provider.dart';
import '../theme/app_theme.dart';
import 'package:clawbox/l10n/app_localizations.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with WidgetsBindingObserver {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() {
      ref.read(instanceProvider.notifier).refresh(includeChannels: true);
      ref.read(usageProvider.notifier).refresh();
    });
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      ref.read(instanceProvider.notifier).refresh(includeChannels: true);
      ref.read(usageProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(instanceProvider.notifier).refresh(includeChannels: true);
      ref.read(usageProvider.notifier).refresh();
    }
  }

  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 18) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final instanceState = ref.watch(instanceProvider);
    final channelState = ref.watch(channelProvider);
    final usageState = ref.watch(usageProvider);
    final instance = instanceState.instance;
    final user = authState.user;

    final telegramInfo = channelState.channels[ChannelType.telegram];
    final whatsappInfo = channelState.channels[ChannelType.whatsapp];
    final discordInfo = channelState.channels[ChannelType.discord];

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _greeting(l10n),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (user != null)
              Text(
                user.name ?? user.email,
                style: Theme.of(context).textTheme.titleMedium,
              ),
          ],
        ),
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                backgroundImage: user.avatarUrl != null
                    ? NetworkImage(user.avatarUrl!)
                    : null,
                child: user.avatarUrl == null
                    ? Icon(Icons.person, color: AppColors.accent, size: 18)
                    : null,
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.read(instanceProvider.notifier).refresh(includeChannels: true),
            ref.read(usageProvider.notifier).refresh(),
          ]);
        },
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Chat CTA
            if (instance != null)
              Card(
                clipBehavior: Clip.antiAlias,
                color: AppColors.accent.withValues(alpha: 0.06),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: AppColors.accent.withValues(alpha: 0.25)),
                ),
                child: InkWell(
                  onTap: () => context.push('/dashboard/chat'),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: AppColors.accent,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.chatWithAI,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      color: instance.isReady
                                          ? AppColors.accent
                                          : AppColors.textTertiary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      instance.isReady
                                          ? l10n.agentReady
                                          : l10n.agentStarting,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: instance.isReady
                                            ? AppColors.accent
                                            : AppColors.textTertiary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.accent.withValues(alpha: 0.7),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Status Row — Instance + Channels, equal height
            if (instance != null)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Instance Status
                    Expanded(
                      child: _StatusTile(
                        icon: Icons.dns_outlined,
                        label: l10n.instance,
                        statusDot: instance.isReady ? AppColors.accent : AppColors.textTertiary,
                        statusText: instance.isReady
                            ? l10n.statusRunning
                            : (instance.manager?.phase ?? l10n.statusWaiting),
                        statusColor: instance.isReady ? AppColors.accent : AppColors.textTertiary,
                        subtitle: instance.displayName,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Channels Status
                    Expanded(
                      child: _StatusTile(
                        icon: Icons.forum_outlined,
                        label: l10n.channels,
                        onTap: () => context.push('/dashboard/channels'),
                        trailing: channelState.totalPending > 0
                            ? _PendingBadge(count: channelState.totalPending)
                            : null,
                        statusWidget: Row(
                          children: [
                            _ChannelDot(
                              icon: Icons.telegram,
                              color: const Color(0xFF26A5E4),
                              isConnected: telegramInfo?.isConnected ?? false,
                            ),
                            const SizedBox(width: 6),
                            _ChannelDot(
                              iconData: FontAwesomeIcons.whatsapp,
                              color: const Color(0xFF25D366),
                              isConnected: whatsappInfo?.isConnected ?? false,
                            ),
                            const SizedBox(width: 6),
                            _ChannelDot(
                              iconData: FontAwesomeIcons.discord,
                              color: const Color(0xFF5865F2),
                              isConnected: discordInfo?.isConnected ?? false,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // AI Usage
            if (instance != null && usageState.usage != null && usageState.usage!.hasLimit)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: _UsageCard(usage: usageState.usage!),
              ),
            // Remote View
            if (instance != null && instance.isReady)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: _RemoteViewCard(),
              ),
            // Web Access Section
            if (instance != null && instance.manager?.gatewayUrl != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: _WebAccessCard(manager: instance.manager!),
              ),
          ],
        ),
      ),
    );
  }
}

/// Unified status tile used for both Instance and Channels
class _StatusTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? statusDot;
  final String? statusText;
  final Color? statusColor;
  final String? subtitle;
  final Widget? statusWidget;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _StatusTile({
    required this.icon,
    required this.label,
    this.statusDot,
    this.statusText,
    this.statusColor,
    this.subtitle,
    this.statusWidget,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Icon(icon, color: AppColors.textSecondary, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  ?trailing,
                  if (onTap != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textTertiary,
                        size: 14,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              // Status content
              if (statusWidget != null)
                statusWidget!
              else if (statusText != null)
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: statusDot ?? AppColors.textTertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        statusText!,
                        style: TextStyle(
                          color: statusColor ?? AppColors.textTertiary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              // Subtitle (fills remaining space to help equalize height)
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PendingBadge extends StatelessWidget {
  final int count;
  const _PendingBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
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

class _ChannelDot extends StatelessWidget {
  final IconData? icon;
  final IconData? iconData;
  final Color color;
  final bool isConnected;

  const _ChannelDot({
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
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: effectiveColor.withValues(alpha: isConnected ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: iconData != null
                ? FaIcon(
                    iconData!,
                    color: effectiveColor.withValues(alpha: isConnected ? 1.0 : 0.5),
                    size: 13,
                  )
                : Icon(
                    icon,
                    color: effectiveColor.withValues(alpha: isConnected ? 1.0 : 0.5),
                    size: 14,
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
              color: isConnected ? AppColors.accentGreen : AppColors.textTertiary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surface, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _RemoteViewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/dashboard/remote-view'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.desktop_windows, color: AppColors.textSecondary, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      l10n.remoteView,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right,
                      color: AppColors.textTertiary, size: 18),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                l10n.remoteViewDescription,
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WebAccessCard extends StatelessWidget {
  final ManagerStatus manager;
  const _WebAccessCard({required this.manager});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final gatewayReady = manager.gatewayReady ?? false;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: gatewayReady
            ? () {
                final url = manager.gatewayUrl;
                final token = manager.gatewayToken;
                if (url != null) {
                  final webUrl = token != null ? '$url#token=$token' : url;
                  launchUrl(Uri.parse(webUrl),
                      mode: LaunchMode.externalApplication);
                }
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.language, color: AppColors.textSecondary, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      l10n.webAccess,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  if (gatewayReady)
                    Icon(Icons.chevron_right,
                        color: AppColors.textTertiary, size: 18),
                ],
              ),
              const SizedBox(height: 10),
              if (!gatewayReady) ...[
                // Preparing state — show sub-statuses
                Row(
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.webAccessPreparing,
                        style: TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Ingress status
                _GatewaySubStatus(
                  label: l10n.gatewayNetwork,
                  ready: manager.ingress?.ready ?? false,
                  detail: manager.ingress?.ip,
                ),
                const SizedBox(height: 4),
                // Certificate status
                _GatewaySubStatus(
                  label: l10n.gatewayCertificate,
                  ready: manager.certificate?.ready ?? false,
                  detail: manager.certificate?.status,
                ),
              ] else ...[
                // Ready state — show URL
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        manager.gatewayUrl ?? '',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _UsageCard extends StatelessWidget {
  final Usage usage;
  const _UsageCard({required this.usage});

  String _resetLabel(AppLocalizations l10n) {
    switch (usage.limitReset) {
      case 'monthly':
        return l10n.resetsMonthly;
      case 'daily':
        return l10n.resetsDaily;
      default:
        return l10n.resetsWeekly;
    }
  }

  Color _barColor(double fraction) {
    if (fraction >= 0.9) return AppColors.error;
    if (fraction >= 0.7) return AppColors.warning;
    return AppColors.accent;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fraction = usage.fraction;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.bar_chart, color: AppColors.textSecondary, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.aiUsage,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Text(
                  _resetLabel(l10n),
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 6,
                backgroundColor: AppColors.surfaceLight,
                valueColor: AlwaysStoppedAnimation<Color>(_barColor(fraction)),
              ),
            ),
            const SizedBox(height: 8),
            // Percentage label
            Text(
              '${usage.usage} / 100',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GatewaySubStatus extends StatelessWidget {
  final String label;
  final bool ready;
  final String? detail;
  const _GatewaySubStatus({
    required this.label,
    required this.ready,
    this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          ready ? Icons.check_circle : Icons.circle_outlined,
          size: 14,
          color: ready ? AppColors.accent : AppColors.textTertiary,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        if (detail != null) ...[
          const SizedBox(width: 4),
          Text(
            detail!,
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }
}

