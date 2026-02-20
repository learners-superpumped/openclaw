import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:clawbox/l10n/app_localizations.dart';
import '../models/skill.dart';
import '../providers/clawhub_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/loading_button.dart';

// ─── Color palette & helpers (shared with skills_screen) ────────────────

const _kSkillColors = [
  Color(0xFF5E6AD2),
  Color(0xFF26B5CE),
  Color(0xFFE5484D),
  Color(0xFFF76B15),
  Color(0xFF46A758),
  Color(0xFF6E56CF),
  Color(0xFF0091FF),
  Color(0xFFE93D82),
  Color(0xFFFFC53D),
  Color(0xFF30A46C),
  Color(0xFFE54666),
  Color(0xFF3E63DD),
];

Color _colorFromSlug(String slug) =>
    _kSkillColors[slug.hashCode.abs() % _kSkillColors.length];

String _iconLetters(String text) {
  final parts = text.split(RegExp(r'[\s\-_/]+'));
  if (parts.length >= 2) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
  return text.substring(0, text.length >= 2 ? 2 : 1).toUpperCase();
}

// ─── Skill Icon ─────────────────────────────────────────────────────────

class _SkillIcon extends StatelessWidget {
  final String slug;
  final String name;
  final double size;

  const _SkillIcon({
    required this.slug,
    required this.name,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    final color = _colorFromSlug(slug);
    final radius = size * 0.22;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: Text(
        _iconLetters(name.isNotEmpty ? name : slug),
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.36,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

// ─── Main screen ────────────────────────────────────────────────────────

class SkillDetailScreen extends ConsumerStatefulWidget {
  final String slug;

  const SkillDetailScreen({super.key, required this.slug});

  @override
  ConsumerState<SkillDetailScreen> createState() => _SkillDetailScreenState();
}

class _SkillDetailScreenState extends ConsumerState<SkillDetailScreen> {
  BrowseSkillDetail? _detail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final detail = await ref.read(clawHubProvider.notifier).getSkillDetail(widget.slug);
      if (mounted) setState(() { _detail = detail; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _handleInstall(AppLocalizations l10n) async {
    try {
      await ref.read(clawHubProvider.notifier).installSkill(widget.slug);
      await _loadDetail();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.installSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        final detail = e is DioException
            ? (e.response?.data?['message'] ?? e.response?.data?['error'] ?? l10n.installFailed)
            : l10n.installFailed;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(detail.toString())),
        );
      }
    }
  }

  Future<void> _handleUninstall(AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.uninstallConfirmTitle),
        content: Text(l10n.uninstallConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.uninstall, style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(clawHubProvider.notifier).uninstallSkill(widget.slug);
      await _loadDetail();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.uninstallSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        final detail = e is DioException
            ? (e.response?.data?['message'] ?? e.response?.data?['error'] ?? l10n.uninstallFailed)
            : l10n.uninstallFailed;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(detail.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final clawHubState = ref.watch(clawHubProvider);
    final isInstalling = clawHubState.installingSlugs.contains(widget.slug);
    final isUninstalling = clawHubState.uninstallingSlugs.contains(widget.slug);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const SizedBox.shrink(),
      ),
      body: _buildBody(context, l10n, isInstalling, isUninstalling),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n, bool isInstalling, bool isUninstalling) {
    if (_isLoading) {
      return const _DetailSkeleton();
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline, color: AppColors.error, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _loadDetail,
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    final detail = _detail!;
    final isBusy = isInstalling || isUninstalling;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      children: [
        // ── Header: icon + name + author ──
        _DetailHeader(slug: detail.slug, detail: detail),
        const SizedBox(height: 24),

        // ── Info bar ──
        _InfoBar(detail: detail, l10n: l10n),
        const SizedBox(height: 24),

        // ── Action button ──
        LoadingButton(
          isLoading: isBusy,
          onPressed: isBusy
              ? null
              : detail.installed
                  ? () => _handleUninstall(l10n)
                  : () => _handleInstall(l10n),
          outlined: detail.installed,
          label: Text(
            isInstalling
                ? l10n.installing
                : isUninstalling
                    ? l10n.uninstalling
                    : detail.installed
                        ? l10n.uninstall
                        : l10n.install,
          ),
          icon: !isBusy
              ? Icon(detail.installed ? Icons.delete_outline : Icons.download_rounded)
              : null,
        ),
        const SizedBox(height: 24),

        // ── Summary ──
        if (detail.summary != null) ...[
          Text(
            detail.summary!,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
        ],

        // ── Changelog ──
        if (detail.changelog != null) ...[
          const Divider(),
          const SizedBox(height: 16),
          if (detail.latestVersion != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'Version ${detail.latestVersion}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              detail.changelog!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Detail Header ──────────────────────────────────────────────────────

class _DetailHeader extends StatelessWidget {
  final String slug;
  final BrowseSkillDetail detail;

  const _DetailHeader({required this.slug, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SkillIcon(
          slug: slug,
          name: detail.name ?? slug,
          size: 80,
        ),
        const SizedBox(height: 16),
        Text(
          detail.name ?? detail.slug,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        if (detail.author != null) ...[
          const SizedBox(height: 4),
          Text(
            detail.author!,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.accent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Info Bar (App Store style) ─────────────────────────────────────────

class _InfoBar extends StatelessWidget {
  final BrowseSkillDetail detail;
  final AppLocalizations l10n;

  const _InfoBar({required this.detail, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final items = <_InfoBarItem>[];

    if (detail.latestVersion != null) {
      items.add(_InfoBarItem(
        label: l10n.version.toUpperCase(),
        value: detail.latestVersion!,
      ));
    }

    items.add(_InfoBarItem(
      label: 'STATUS',
      value: detail.installed ? l10n.installed : '---',
    ));

    if (detail.author != null) {
      items.add(_InfoBarItem(
        label: 'AUTHOR',
        value: detail.author!,
      ));
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              if (i > 0)
                Container(
                  width: 0.5,
                  color: AppColors.border,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      items[i].label,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      items[i].value,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoBarItem {
  final String label;
  final String value;
  const _InfoBarItem({required this.label, required this.value});
}

// ─── Skeleton loader ────────────────────────────────────────────────────

class _DetailSkeleton extends StatefulWidget {
  const _DetailSkeleton();

  @override
  State<_DetailSkeleton> createState() => _DetailSkeletonState();
}

class _DetailSkeletonState extends State<_DetailSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _bone(double width, double height, {double radius = 6}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color(0x33FFFFFF),
                Color(0x11FFFFFF),
                Color(0x33FFFFFF),
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ],
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child!,
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
        child: Column(
          children: [
            _bone(80, 80, radius: 80 * 0.22),
            const SizedBox(height: 16),
            _bone(160, 20),
            const SizedBox(height: 8),
            _bone(100, 14),
            const SizedBox(height: 24),
            _bone(double.infinity, 52, radius: 12),
            const SizedBox(height: 24),
            _bone(double.infinity, 48, radius: 12),
            const SizedBox(height: 24),
            _bone(double.infinity, 16),
            const SizedBox(height: 8),
            _bone(double.infinity, 16),
            const SizedBox(height: 8),
            _bone(200, 16),
          ],
        ),
      ),
    );
  }
}
