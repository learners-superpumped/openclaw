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
import '../providers/instance_provider.dart';
import '../providers/usage_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import 'package:clawbox/l10n/app_localizations.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  Timer? _refreshTimer;
  late final AnimationController _staggerController;
  late final AnimationController _orbController;

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

    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    _staggerController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(instanceProvider.notifier).refresh(includeChannels: true);
      ref.read(usageProvider.notifier).refresh();
    }
  }

  Animation<double> _staggerAnimation(double begin, double end) {
    return CurvedAnimation(
      parent: _staggerController,
      curve: Interval(begin, end, curve: Curves.easeOutCubic),
    );
  }

  @override
  Widget build(BuildContext context) {
    final instanceState = ref.watch(instanceProvider);
    final channelState = ref.watch(channelProvider);
    final usageState = ref.watch(usageProvider);
    final instance = instanceState.instance;

    final telegramInfo = channelState.channels[ChannelType.telegram];
    final whatsappInfo = channelState.channels[ChannelType.whatsapp];
    final discordInfo = channelState.channels[ChannelType.discord];

    return Scaffold(
      body: Stack(
        children: [
          // Atmospheric background
          _AtmosphericBackground(animation: _orbController),
          // Main content
          SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  ref.read(instanceProvider.notifier).refresh(includeChannels: true),
                  ref.read(usageProvider.notifier).refresh(),
                ]);
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Minimal header
                  SizedBox(
                    height: kToolbarHeight,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ClawBox',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                  // Chat Hero Tile
                  if (instance != null)
                    _StaggeredEntry(
                      animation: _staggerAnimation(0.0, 0.3),
                      child: _ChatHeroTile(
                        isReady: instance.isReady,
                        onTap: () => context.push('/dashboard/chat'),
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Bento Status Row
                  if (instance != null)
                    _StaggeredEntry(
                      animation: _staggerAnimation(0.08, 0.38),
                      child: _BentoStatusRow(
                        instance: instance,
                        channelState: channelState,
                        telegramInfo: telegramInfo,
                        whatsappInfo: whatsappInfo,
                        discordInfo: discordInfo,
                        onChannelsTap: () => context.push('/dashboard/channels'),
                      ),
                    ),
                  // AI Usage
                  if (instance != null && usageState.usage != null && usageState.usage!.hasLimit) ...[
                    const SizedBox(height: 16),
                    _StaggeredEntry(
                      animation: _staggerAnimation(0.16, 0.46),
                      child: _UsageTile(usage: usageState.usage!),
                    ),
                  ],
                  // Quick Access Row
                  if (instance != null) ...[
                    const SizedBox(height: 16),
                    _StaggeredEntry(
                      animation: _staggerAnimation(0.24, 0.54),
                      child: _QuickAccessRow(
                        instance: instance,
                        onRemoteViewTap: instance.isReady
                            ? () => context.push('/dashboard/remote-view')
                            : null,
                      ),
                    ),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Staggered Entry Animation ─────────────────────────────────────────────

class _StaggeredEntry extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _StaggeredEntry({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - animation.value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

// ─── Atmospheric Background ────────────────────────────────────────────────

class _AtmosphericBackground extends StatelessWidget {
  final AnimationController animation;

  const _AtmosphericBackground({required this.animation});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final v = animation.value;
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D0D0F),
                  AppColors.background,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Orb 1: Cyan, top-right
                Positioned(
                  right: -60 + (v * 20),
                  top: 40 + (v * 15),
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          GlassColors.orbCyan.withValues(alpha: 0.08),
                          GlassColors.orbCyan.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                // Orb 2: Purple, bottom-left
                Positioned(
                  left: -50 + (v * 10),
                  bottom: 200 - (v * 20),
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          GlassColors.orbPurple.withValues(alpha: 0.06),
                          GlassColors.orbPurple.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                // Orb 3: Teal, center-right
                Positioned(
                  right: 20 - (v * 15),
                  top: 350 + (v * 10),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          GlassColors.orbTeal.withValues(alpha: 0.05),
                          GlassColors.orbTeal.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Chat Hero Tile ────────────────────────────────────────────────────────

class _ChatHeroTile extends StatelessWidget {
  final bool isReady;
  final VoidCallback onTap;

  const _ChatHeroTile({required this.isReady, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GlassCard(
      glowColor: AppColors.accent,
      glowIntensity: 0.5,
      padding: const EdgeInsets.all(24),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _PulsingGlowIcon(
                icon: Icons.auto_awesome,
                color: AppColors.accent,
                size: 48,
              ),
              const Spacer(),
              _StatusPill(isReady: isReady),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.chatWithAI,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(
            isReady ? l10n.agentReady : l10n.agentStarting,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Spacer(),
              Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.accent.withValues(alpha: 0.7),
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Pulsing Glow Icon ─────────────────────────────────────────────────────

class _PulsingGlowIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;

  const _PulsingGlowIcon({
    required this.icon,
    required this.color,
    this.size = 48,
  });

  @override
  State<_PulsingGlowIcon> createState() => _PulsingGlowIconState();
}

class _PulsingGlowIconState extends State<_PulsingGlowIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final glowOpacity = 0.1 + (_controller.value * 0.15);
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withValues(alpha: glowOpacity),
          ),
          child: child,
        );
      },
      child: Icon(
        widget.icon,
        color: widget.color,
        size: widget.size * 0.5,
      ),
    );
  }
}

// ─── Status Pill ───────────────────────────────────────────────────────────

class _StatusPill extends StatelessWidget {
  final bool isReady;

  const _StatusPill({required this.isReady});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = isReady ? AppColors.accent : AppColors.textTertiary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            isReady ? l10n.agentReady : l10n.agentStarting,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bento Status Row ──────────────────────────────────────────────────────

class _BentoStatusRow extends StatelessWidget {
  final Instance instance;
  final dynamic channelState;
  final dynamic telegramInfo;
  final dynamic whatsappInfo;
  final dynamic discordInfo;
  final VoidCallback onChannelsTap;

  const _BentoStatusRow({
    required this.instance,
    required this.channelState,
    this.telegramInfo,
    this.whatsappInfo,
    this.discordInfo,
    required this.onChannelsTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = (constraints.maxWidth - 12) / 2;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instance tile
            SizedBox(
              width: tileWidth,
              child: GlassCard.solid(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.instance.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.dns_outlined,
                          color: AppColors.textSecondary,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        _PulsingDot(
                          color: instance.isReady ? AppColors.accent : AppColors.textTertiary,
                          isActive: instance.isReady,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      instance.isReady
                          ? l10n.statusRunning
                          : (instance.manager?.phase ?? l10n.statusWaiting),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: instance.isReady ? AppColors.accent : AppColors.textTertiary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    if (instance.displayName != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        instance.displayName!,
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Channels tile
            SizedBox(
              width: tileWidth,
              child: GlassCard.solid(
                padding: const EdgeInsets.all(16),
                onTap: onChannelsTap,
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
                        _ChannelIcon(
                          iconData: FontAwesomeIcons.whatsapp,
                          color: const Color(0xFF25D366),
                          isConnected: whatsappInfo?.isConnected ?? false,
                        ),
                        const SizedBox(width: 8),
                        _ChannelIcon(
                          iconData: FontAwesomeIcons.discord,
                          color: const Color(0xFF5865F2),
                          isConnected: discordInfo?.isConnected ?? false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.channelsSummary(_connectedCount()),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  int _connectedCount() {
    int count = 0;
    if (telegramInfo?.isConnected ?? false) count++;
    if (whatsappInfo?.isConnected ?? false) count++;
    if (discordInfo?.isConnected ?? false) count++;
    return count;
  }
}

// ─── Pulsing Dot ───────────────────────────────────────────────────────────

class _PulsingDot extends StatefulWidget {
  final Color color;
  final bool isActive;

  const _PulsingDot({required this.color, required this.isActive});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    if (widget.isActive) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(_PulsingDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isActive && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final scale = widget.isActive ? 1.0 + (_controller.value * 0.3) : 1.0;
        return Container(
          width: 10 * scale,
          height: 10 * scale,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.4 * _controller.value),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        );
      },
    );
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
                    color: effectiveColor.withValues(alpha: isConnected ? 1.0 : 0.5),
                    size: 15,
                  )
                : Icon(
                    icon,
                    color: effectiveColor.withValues(alpha: isConnected ? 1.0 : 0.5),
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
              color: isConnected ? AppColors.accentGreen : AppColors.textTertiary,
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

// ─── Usage Tile ────────────────────────────────────────────────────────────

class _UsageTile extends StatelessWidget {
  final Usage usage;
  const _UsageTile({required this.usage});

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
    final color = _barColor(fraction);

    return GlassCard.solid(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.aiUsage.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const Spacer(),
              Text(
                _resetLabel(l10n),
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${usage.usage}',
                style: TextStyle(
                  color: color,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  ' / 100',
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: fraction),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return CustomPaint(
                size: const Size(double.infinity, 8),
                painter: _GlassProgressPainter(
                  fraction: value,
                  color: color,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Glass Progress Bar Painter ────────────────────────────────────────────

class _GlassProgressPainter extends CustomPainter {
  final double fraction;
  final Color color;

  _GlassProgressPainter({required this.fraction, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = GlassColors.glassSurface
      ..style = PaintingStyle.fill;

    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(4),
    );
    canvas.drawRRect(bgRect, bgPaint);

    if (fraction > 0) {
      final fillWidth = size.width * fraction;
      final fillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, fillWidth, size.height),
        const Radius.circular(4),
      );

      final fillPaint = Paint()
        ..shader = LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
        ).createShader(Rect.fromLTWH(0, 0, fillWidth, size.height))
        ..style = PaintingStyle.fill;

      canvas.drawRRect(fillRect, fillPaint);

      // Glow effect
      final glowPaint = Paint()
        ..shader = LinearGradient(
          colors: [color.withValues(alpha: 0.4), color.withValues(alpha: 0.0)],
        ).createShader(Rect.fromLTWH(0, 0, fillWidth, size.height))
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawRRect(fillRect, glowPaint);
    }
  }

  @override
  bool shouldRepaint(_GlassProgressPainter oldDelegate) {
    return oldDelegate.fraction != fraction || oldDelegate.color != color;
  }
}

// ─── Quick Access Row ──────────────────────────────────────────────────────

class _QuickAccessRow extends StatelessWidget {
  final Instance instance;
  final VoidCallback? onRemoteViewTap;

  const _QuickAccessRow({
    required this.instance,
    this.onRemoteViewTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final manager = instance.manager;
    final gatewayReady = manager?.gatewayReady ?? false;

    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = (constraints.maxWidth - 12) / 2;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Remote View
            SizedBox(
              width: tileWidth,
              child: GlassCard.solid(
                padding: const EdgeInsets.all(16),
                onTap: onRemoteViewTap,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.desktop_windows,
                      color: AppColors.textSecondary,
                      size: 24,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.remoteView,
                      style: Theme.of(context).textTheme.titleMedium,
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
              ),
            ),
            const SizedBox(width: 12),
            // Web Access
            SizedBox(
              width: tileWidth,
              child: _buildWebAccessTile(context, l10n, manager, gatewayReady),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWebAccessTile(
    BuildContext context,
    AppLocalizations l10n,
    ManagerStatus? manager,
    bool gatewayReady,
  ) {
    if (manager?.gatewayUrl != null) {
      return GlassCard.solid(
        padding: const EdgeInsets.all(16),
        onTap: gatewayReady
            ? () {
                final url = manager!.gatewayUrl;
                final token = manager.gatewayToken;
                if (url != null) {
                  final webUrl = token != null ? '$url#token=$token' : url;
                  launchUrl(Uri.parse(webUrl),
                      mode: LaunchMode.externalApplication);
                }
              }
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.language,
              color: AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 10),
            Text(
              l10n.webAccess,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            if (!gatewayReady)
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
              )
            else
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
                      manager?.gatewayUrl ?? '',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
    }

    return GlassCard.solid(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.language,
            color: AppColors.textTertiary,
            size: 24,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.webAccess,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.webAccessPreparing,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
