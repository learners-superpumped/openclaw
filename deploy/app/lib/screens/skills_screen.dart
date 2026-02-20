import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:clawbox/l10n/app_localizations.dart';
import '../providers/clawhub_provider.dart';
import '../theme/app_theme.dart';

// ─── Color palette & helpers ────────────────────────────────────────────

const _kSkillColors = [
  Color(0xFF5E6AD2), // Indigo
  Color(0xFF26B5CE), // Teal
  Color(0xFFE5484D), // Coral
  Color(0xFFF76B15), // Orange
  Color(0xFF46A758), // Green
  Color(0xFF6E56CF), // Purple
  Color(0xFF0091FF), // Blue
  Color(0xFFE93D82), // Pink
  Color(0xFFFFC53D), // Amber
  Color(0xFF30A46C), // Emerald
  Color(0xFFE54666), // Rose
  Color(0xFF3E63DD), // Royal Blue
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

// ─── Skill Icon (iOS app-icon style) ────────────────────────────────────

class _SkillIcon extends StatelessWidget {
  final String slug;
  final String name;
  final double size;

  const _SkillIcon({
    required this.slug,
    required this.name,
    this.size = 48,
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

class SkillsScreen extends ConsumerStatefulWidget {
  const SkillsScreen({super.key});

  @override
  ConsumerState<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends ConsumerState<SkillsScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(() => ref.read(clawHubProvider.notifier).loadSkills());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(clawHubProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(clawHubProvider.notifier).loadSkills(q: query.isEmpty ? null : query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(clawHubProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(l10n.skills),
      ),
      body: Column(
        children: [
          // ── Search bar ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                textInputAction: TextInputAction.search,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  hintText: l10n.searchSkills,
                  prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textTertiary),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // ── Filter toggle ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: _PillToggle(
              labels: [l10n.allSkills, l10n.installed],
              selectedIndex: state.filterInstalled ? 1 : 0,
              onChanged: (index) {
                ref.read(clawHubProvider.notifier).setFilterInstalled(index == 1);
              },
            ),
          ),

          // ── Body ──
          Expanded(
            child: _buildBody(context, l10n, state),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n, ClawHubState state) {
    if (state.isLoading && state.skills.isEmpty) {
      return const _SkillListSkeleton();
    }

    if (state.error != null && state.skills.isEmpty) {
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
              child: const Icon(Icons.wifi_off_rounded, color: AppColors.error, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              state.error!,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => ref.read(clawHubProvider.notifier).loadSkills(q: state.searchQuery),
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    final filteredSkills = ref.read(clawHubProvider.notifier).filteredSkills;

    if (filteredSkills.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.textTertiary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.extension_off_outlined, color: AppColors.textTertiary, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noSkillsFound,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
            ),
          ],
        ),
      );
    }

    final itemCount = filteredSkills.length + (state.isLoadingMore ? 1 : 0);

    return RefreshIndicator(
      onRefresh: () => ref.read(clawHubProvider.notifier).loadSkills(q: state.searchQuery),
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const Divider(indent: 80, height: 1),
        itemBuilder: (context, index) {
          if (index >= filteredSkills.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }

          final skill = filteredSkills[index];
          final isInstalling = state.installingSlugs.contains(skill.slug);
          final isUninstalling = state.uninstallingSlugs.contains(skill.slug);

          return _SkillListItem(
            skill: skill,
            isInstalling: isInstalling,
            isUninstalling: isUninstalling,
            onTap: () => context.push('/dashboard/skills/${skill.slug}'),
            onInstall: () async {
              try {
                await ref.read(clawHubProvider.notifier).installSkill(skill.slug);
              } catch (e) {
                if (!context.mounted) return;
                final l10n = AppLocalizations.of(context)!;
                final detail = e is DioException
                    ? (e.response?.data?['message'] ?? e.response?.data?['error'] ?? l10n.installFailed)
                    : l10n.installFailed;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(detail.toString())),
                );
              }
            },
            onUninstall: () => _confirmUninstall(context, l10n, skill.slug),
          );
        },
      ),
    );
  }

  void _confirmUninstall(BuildContext context, AppLocalizations l10n, String slug) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.uninstallConfirmTitle),
        content: Text(l10n.uninstallConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ref.read(clawHubProvider.notifier).uninstallSkill(slug);
              } catch (e) {
                if (!context.mounted) return;
                final detail = e is DioException
                    ? (e.response?.data?['message'] ?? e.response?.data?['error'] ?? l10n.uninstallFailed)
                    : l10n.uninstallFailed;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(detail.toString())),
                );
              }
            },
            child: Text(l10n.uninstall, style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

// ─── Pill Toggle (iOS-style) ────────────────────────────────────────────

class _PillToggle extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _PillToggle({
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isSelected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─── Skill List Item ────────────────────────────────────────────────────

class _SkillListItem extends StatelessWidget {
  final dynamic skill;
  final bool isInstalling;
  final bool isUninstalling;
  final VoidCallback onTap;
  final VoidCallback onInstall;
  final VoidCallback onUninstall;

  const _SkillListItem({
    required this.skill,
    required this.isInstalling,
    required this.isUninstalling,
    required this.onTap,
    required this.onInstall,
    required this.onUninstall,
  });

  @override
  Widget build(BuildContext context) {
    final isBusy = isInstalling || isUninstalling;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _SkillIcon(
              slug: skill.slug,
              name: skill.name ?? skill.slug,
              size: 48,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skill.name ?? skill.slug,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (skill.summary != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      skill.summary!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            _GetButton(
              isInstalled: skill.installed,
              isBusy: isBusy,
              onPressed: skill.installed ? onUninstall : onInstall,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── GET Button (App Store style) ───────────────────────────────────────

class _GetButton extends StatelessWidget {
  final bool isInstalled;
  final bool isBusy;
  final VoidCallback onPressed;

  const _GetButton({
    required this.isInstalled,
    required this.isBusy,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (isBusy) {
      return const SizedBox(
        width: 68,
        height: 28,
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: 68,
      height: 28,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: isInstalled
              ? Colors.transparent
              : AppColors.accent.withValues(alpha: 0.12),
          foregroundColor: isInstalled ? AppColors.textTertiary : AppColors.accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: isInstalled
                ? const BorderSide(color: AppColors.border, width: 1)
                : BorderSide.none,
          ),
        ),
        child: Text(
          isInstalled ? l10n.installed : 'GET',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isInstalled ? AppColors.textTertiary : AppColors.accent,
          ),
        ),
      ),
    );
  }
}

// ─── Skeleton loader ────────────────────────────────────────────────────

class _SkillListSkeleton extends StatefulWidget {
  const _SkillListSkeleton();

  @override
  State<_SkillListSkeleton> createState() => _SkillListSkeletonState();
}

class _SkillListSkeletonState extends State<_SkillListSkeleton>
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
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 24),
        itemCount: 8,
        separatorBuilder: (_, _) => const Divider(indent: 80, height: 1),
        itemBuilder: (_, _) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(48 * 0.22),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 68,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
