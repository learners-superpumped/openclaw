import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/channel.dart';
import '../../providers/channel_provider.dart';
import '../../providers/instance_provider.dart';
import '../../providers/model_config_provider.dart';
import '../../providers/usage_provider.dart';
import 'atmospheric_background.dart';
import 'channels_tile.dart';
import 'chat_hero_tile.dart';
import 'default_model_tile.dart';
import 'instance_tile.dart';
import 'remote_view_tile.dart';
import 'usage_tile.dart';
import 'web_access_tile.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  Timer? _refreshTimer;
  Timer? _fastPollTimer;
  late final AnimationController _staggerController;
  late final AnimationController _orbController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() {
      ref.read(instanceProvider.notifier).refresh(includeChannels: true);
      _loadModelConfig();
    });
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      ref.read(instanceProvider.notifier).refresh(includeChannels: true);
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
    _fastPollTimer?.cancel();
    _staggerController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(instanceProvider.notifier).refresh(includeChannels: true);
      _loadModelConfig();
    }
  }

  void _startFastPolling() {
    _fastPollTimer?.cancel();
    int ticks = 0;
    _fastPollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      ticks++;
      ref.read(instanceProvider.notifier).refresh(includeChannels: true);

      final instance = ref.read(instanceProvider).instance;
      if ((instance?.isReady ?? false) && ticks > 2) {
        _fastPollTimer?.cancel();
        _fastPollTimer = null;
        _loadModelConfig();
      }
      if (ticks >= 20) {
        _fastPollTimer?.cancel();
        _fastPollTimer = null;
      }
    });
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
          AtmosphericBackground(animation: _orbController),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(instanceProvider.notifier)
                    .refresh(includeChannels: true);
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
                    tiles.add(
                      _BentoTile(
                        key: 'hero',
                        span: cols,
                        stagger: _staggerAnimation(0.0, 0.3),
                        child: ChatHeroTile(
                          isReady: instance.isReady,
                          onTap: instance.isReady
                              ? () => context.push('/dashboard/chat')
                              : null,
                        ),
                      ),
                    );

                    tiles.add(
                      _BentoTile(
                        key: 'instance',
                        stagger: _staggerAnimation(0.06, 0.36),
                        child: InstanceTile(instance: instance),
                      ),
                    );

                    tiles.add(
                      _BentoTile(
                        key: 'channels',
                        stagger: _staggerAnimation(0.12, 0.42),
                        child: ChannelsTile(
                          channelState: channelState,
                          telegramInfo: telegramInfo,
                          whatsappInfo: whatsappInfo,
                          discordInfo: discordInfo,
                          isReady: instance.isReady,
                          onTap: () => context.push('/dashboard/channels'),
                        ),
                      ),
                    );

                    tiles.add(
                      _BentoTile(
                        key: 'model',
                        span: cols,
                        stagger: _staggerAnimation(0.18, 0.48),
                        child: DefaultModelTile(
                          instanceId: instance.instanceId,
                          isReady: instance.isReady,
                          onModelChanged: _startFastPolling,
                        ),
                      ),
                    );

                    tiles.add(
                      _BentoTile(
                        key: 'usage',
                        span: cols,
                        stagger: _staggerAnimation(0.24, 0.54),
                        child: UsageTile(
                          usage: usageState.usage,
                          isLoading:
                              usageState.isLoading && usageState.usage == null,
                        ),
                      ),
                    );

                    tiles.add(
                      _BentoTile(
                        key: 'remote',
                        stagger: _staggerAnimation(0.30, 0.60),
                        child: RemoteViewTile(
                          isReady: instance.isReady,
                          onTap: () => context.push('/dashboard/remote-view'),
                        ),
                      ),
                    );

                    if (instance.manager?.gatewayUrl != null) {
                      tiles.add(
                        _BentoTile(
                          key: 'web',
                          stagger: _staggerAnimation(0.36, 0.66),
                          child: WebAccessTile(manager: instance.manager!),
                        ),
                      );
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
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(letterSpacing: -0.5),
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
