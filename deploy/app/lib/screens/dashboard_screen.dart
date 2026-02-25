import 'dart:async';
import 'dart:math' as math;
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
import '../providers/model_config_provider.dart';
import '../providers/usage_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/model_picker_sheet.dart';
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
      _loadModelConfig();
    });
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      ref.read(instanceProvider.notifier).refresh(includeChannels: true);
      ref.read(usageProvider.notifier).refresh();
      _loadModelConfig();
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
      _loadModelConfig();
    }
  }

  void _loadModelConfig() {
    final instance = ref.read(instanceProvider).instance;
    if (instance != null && instance.isReady) {
      ref.read(modelConfigProvider.notifier).load(instance.instanceId);
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
          _AtmosphericBackground(animation: _orbController),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  ref.read(instanceProvider.notifier).refresh(includeChannels: true),
                  ref.read(usageProvider.notifier).refresh(),
                ]);
                _loadModelConfig();
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final isWide = width >= 600;
                  final cols = isWide ? (width >= 900 ? 4 : 3) : 2;
                  final maxWidth = isWide ? 900.0 : double.infinity;

                  // Build tile list with stable keys for animation
                  final tiles = <_BentoTile>[];

                  if (instance != null) {
                    tiles.add(_BentoTile(
                      key: 'hero',
                      span: cols,
                      stagger: _staggerAnimation(0.0, 0.3),
                      child: _ChatHeroTile(
                        isReady: instance.isReady,
                        onTap: () => context.push('/dashboard/chat'),
                      ),
                    ));

                    tiles.add(_BentoTile(
                      key: 'instance',
                      stagger: _staggerAnimation(0.06, 0.36),
                      child: _InstanceTile(instance: instance),
                    ));

                    tiles.add(_BentoTile(
                      key: 'channels',
                      stagger: _staggerAnimation(0.12, 0.42),
                      child: _ChannelsTile(
                        channelState: channelState,
                        telegramInfo: telegramInfo,
                        whatsappInfo: whatsappInfo,
                        discordInfo: discordInfo,
                        onTap: () => context.push('/dashboard/channels'),
                      ),
                    ));

                    if (instance.isReady) {
                      tiles.add(_BentoTile(
                        key: 'model',
                        span: cols,
                        stagger: _staggerAnimation(0.18, 0.48),
                        child: _DefaultModelTile(
                          instanceId: instance.instanceId,
                        ),
                      ));
                    }

                    if (usageState.usage != null && usageState.usage!.hasLimit) {
                      tiles.add(_BentoTile(
                        key: 'usage',
                        span: cols,
                        stagger: _staggerAnimation(0.24, 0.54),
                        child: _UsageTile(usage: usageState.usage!),
                      ));
                    }

                    if (instance.isReady) {
                      tiles.add(_BentoTile(
                        key: 'remote',
                        stagger: _staggerAnimation(0.30, 0.60),
                        child: _RemoteViewTile(
                          onTap: () => context.push('/dashboard/remote-view'),
                        ),
                      ));
                    }

                    if (instance.manager?.gatewayUrl != null) {
                      tiles.add(_BentoTile(
                        key: 'web',
                        stagger: _staggerAnimation(0.36, 0.66),
                        child: _WebAccessTile(manager: instance.manager!),
                      ));
                    }
                  }

                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
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
                          _BentoGrid(cols: cols, gap: 12, tiles: tiles),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bento Grid Layout ─────────────────────────────────────────────────────

class _BentoTile {
  final String key;
  final int span;
  final Animation<double> stagger;
  final Widget child;

  const _BentoTile({
    required this.key,
    this.span = 1,
    required this.stagger,
    required this.child,
  });
}

class _BentoGrid extends StatelessWidget {
  final int cols;
  final double gap;
  final List<_BentoTile> tiles;

  const _BentoGrid({
    required this.cols,
    required this.gap,
    required this.tiles,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    int col = 0;
    List<_BentoTile> currentRow = [];

    for (final tile in tiles) {
      final span = tile.span.clamp(1, cols);

      if (col + span > cols && currentRow.isNotEmpty) {
        rows.add(_buildRow(currentRow));
        rows.add(SizedBox(height: gap));
        currentRow = [];
        col = 0;
      }

      currentRow.add(tile);
      col += span;

      if (col >= cols) {
        rows.add(_buildRow(currentRow));
        rows.add(SizedBox(height: gap));
        currentRow = [];
        col = 0;
      }
    }

    if (currentRow.isNotEmpty) {
      rows.add(_buildRow(currentRow));
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: Column(children: rows),
    );
  }

  Widget _buildRow(List<_BentoTile> tiles) {
    final children = tiles.map((tile) {
      return _AnimatedTileEntry(
        key: ValueKey(tile.key),
        stagger: tile.stagger,
        child: tile.child,
      );
    }).toList();

    if (children.length == 1) {
      return children.first;
    }

    final spans = tiles.map((t) => t.span.clamp(1, cols)).toList();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(width: gap),
          Expanded(flex: spans[i], child: children[i]),
        ],
      ],
    );
  }
}

// ─── Animated Tile Entry ───────────────────────────────────────────────────

class _AnimatedTileEntry extends StatefulWidget {
  final Animation<double> stagger;
  final Widget child;

  const _AnimatedTileEntry({
    super.key,
    required this.stagger,
    required this.child,
  });

  @override
  State<_AnimatedTileEntry> createState() => _AnimatedTileEntryState();
}

class _AnimatedTileEntryState extends State<_AnimatedTileEntry>
    with SingleTickerProviderStateMixin {
  AnimationController? _selfController;
  late Animation<double> _activeAnimation;

  @override
  void initState() {
    super.initState();
    // If stagger is already completed (tile added after initial load),
    // run our own entrance animation
    if (widget.stagger.isCompleted) {
      _selfController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      );
      _activeAnimation = CurvedAnimation(
        parent: _selfController!,
        curve: Curves.easeOutCubic,
      );
      _selfController!.forward();
    } else {
      _activeAnimation = widget.stagger;
    }
  }

  @override
  void dispose() {
    _selfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _activeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _activeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _activeAnimation.value)),
            child: child,
          ),
        );
      },
      child: widget.child,
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

class _ChatHeroTile extends StatefulWidget {
  final bool isReady;
  final VoidCallback onTap;

  const _ChatHeroTile({required this.isReady, required this.onTap});

  @override
  State<_ChatHeroTile> createState() => _ChatHeroTileState();
}

class _ChatHeroTileState extends State<_ChatHeroTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat();
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GlassCard(
      glowColor: AppColors.accent,
      glowIntensity: 0.5,
      padding: EdgeInsets.zero,
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Animated glow orbs
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _glowController,
                builder: (context, _) {
                  final t = _glowController.value;
                  // Orb 1: cyan, moves clockwise
                  final x1 = 0.3 + 0.4 * math.cos(t * 2 * math.pi);
                  final y1 = 0.3 + 0.4 * math.sin(t * 2 * math.pi);
                  // Orb 2: purple, moves counter-clockwise, offset phase
                  final x2 = 0.6 - 0.3 * math.cos(t * 2 * math.pi + 2.0);
                  final y2 = 0.7 + 0.3 * math.sin(t * 2 * math.pi + 2.0);
                  // Orb 3: teal, slower drift
                  final x3 = 0.8 + 0.2 * math.sin(t * 2 * math.pi * 0.7);
                  final y3 = 0.2 + 0.3 * math.cos(t * 2 * math.pi * 0.7);

                  return CustomPaint(
                    painter: _GlowOrbsPainter(
                      orbs: [
                        _GlowOrb(x1, y1, 120, GlassColors.orbCyan, 0.12),
                        _GlowOrb(x2, y2, 100, GlassColors.orbPurple, 0.10),
                        _GlowOrb(x3, y3, 80, GlassColors.orbTeal, 0.08),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
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
                      _StatusPill(isReady: widget.isReady),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.chatWithAI,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.isReady ? l10n.agentReady : l10n.agentStarting,
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
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Glow Orbs Painter ─────────────────────────────────────────────────────

class _GlowOrb {
  final double x, y, radius;
  final Color color;
  final double opacity;
  const _GlowOrb(this.x, this.y, this.radius, this.color, this.opacity);
}

class _GlowOrbsPainter extends CustomPainter {
  final List<_GlowOrb> orbs;
  _GlowOrbsPainter({required this.orbs});

  @override
  void paint(Canvas canvas, Size size) {
    for (final orb in orbs) {
      final center = Offset(orb.x * size.width, orb.y * size.height);
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            orb.color.withValues(alpha: orb.opacity),
            orb.color.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: orb.radius))
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, orb.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_GlowOrbsPainter oldDelegate) => true;
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

// ─── Instance Tile ─────────────────────────────────────────────────────────

class _InstanceTile extends StatelessWidget {
  final Instance instance;

  const _InstanceTile({required this.instance});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GlassCard.solid(
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
    );
  }
}

// ─── Channels Tile ─────────────────────────────────────────────────────────

class _ChannelsTile extends StatelessWidget {
  final dynamic channelState;
  final dynamic telegramInfo;
  final dynamic whatsappInfo;
  final dynamic discordInfo;
  final VoidCallback onTap;

  const _ChannelsTile({
    required this.channelState,
    this.telegramInfo,
    this.whatsappInfo,
    this.discordInfo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GlassCard.solid(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
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
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
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

// ─── Remote View Tile ──────────────────────────────────────────────────────

class _RemoteViewTile extends StatelessWidget {
  final VoidCallback onTap;

  const _RemoteViewTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GlassCard.solid(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
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
    );
  }
}

// ─── Web Access Tile ───────────────────────────────────────────────────────

class _WebAccessTile extends StatelessWidget {
  final ManagerStatus manager;

  const _WebAccessTile({required this.manager});

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
            color: gatewayReady ? AppColors.textSecondary : AppColors.textTertiary,
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
              style: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 10,
              ),
            ),
          ]
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
                    manager.gatewayUrl ?? '',
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
}

// ─── Default Model Tile ─────────────────────────────────────────────────────

class _DefaultModelTile extends ConsumerWidget {
  final String instanceId;

  const _DefaultModelTile({required this.instanceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final configState = ref.watch(modelConfigProvider);
    final currentModel = configState.currentModel;
    final defaultModel = configState.defaultModel;

    return GlassCard.solid(
      padding: const EdgeInsets.all(16),
      onTap: () => _openModelPicker(context, ref),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.defaultModel.toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 10),
                if (configState.isLoading && defaultModel == null)
                  SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: AppColors.textTertiary,
                    ),
                  )
                else ...[
                  Text(
                    currentModel?.name ?? defaultModel ?? '—',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: defaultModel != null
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  if (currentModel != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      currentModel.id,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.chevron_right,
            color: AppColors.textTertiary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Future<void> _openModelPicker(BuildContext context, WidgetRef ref) async {
    final configState = ref.read(modelConfigProvider);
    final selected = await ModelPickerSheet.show(
      context,
      models: configState.models,
      currentModelRef: configState.defaultModel,
    );
    if (selected == null || !context.mounted) return;

    final success = await ref
        .read(modelConfigProvider.notifier)
        .setDefaultModel(instanceId, selected.gatewayModelRef);

    if (context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? l10n.gatewayRestartNotice
                : l10n.changeDefaultModelError,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
