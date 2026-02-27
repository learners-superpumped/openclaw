import 'package:clawbox/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../providers/api_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../providers/profile_provider.dart';

class AgentCompleteScreen extends ConsumerWidget {
  const AgentCompleteScreen({super.key});

  String _getCreatureEmoji(String? creature) {
    const map = {
      'cat': '\u{1F431}',
      'dragon': '\u{1F432}',
      'fox': '\u{1F98A}',
      'owl': '\u{1F989}',
      'rabbit': '\u{1F430}',
      'bear': '\u{1F43B}',
      'dino': '\u{1F995}',
      'penguin': '\u{1F427}',
      'person': '\u{1F464}',
      'wolf': '\u{1F43A}',
      'panda': '\u{1F43C}',
      'unicorn': '\u{1F984}',
    };
    return map[creature] ?? '\u{1F916}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.watch(profileProvider);
    final callName = profile.callName.isNotEmpty
        ? profile.callName
        : l10n.commonFallbackFriend;
    final agentName = profile.agentName.isNotEmpty
        ? profile.agentName
        : l10n.commonFallbackYourAgent;
    final creatureEmoji =
        profile.agentEmoji ?? _getCreatureEmoji(profile.creature);
    final tasks = profile.tasks;

    ref.read(analyticsProvider).logOnboardingStepViewed(step: 'agent_complete');

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0B),
      body: Stack(
        children: [
          // Hexgrid background
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding/hexgrid-v3.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Creature display
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: Center(
                              child: Text(
                                creatureEmoji,
                                style: const TextStyle(fontSize: 52),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Title
                          Text(
                            l10n.agentCompleteTitle(agentName, callName),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFEAEAEB),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Subtitle
                          Text(
                            l10n.agentCompleteSubtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8A8B8D),
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Status cards
                          _buildCard(
                            LucideIcons.checkCircle2,
                            l10n.agentCompleteStatus1,
                          ),
                          const SizedBox(height: 10),
                          _buildCard(
                            LucideIcons.cpu,
                            l10n.agentCompleteStatus2,
                          ),
                          const SizedBox(height: 10),
                          _buildCard(
                            LucideIcons.sparkles,
                            l10n.agentCompleteStatus3,
                          ),
                          const SizedBox(height: 10),
                          _buildCard(
                            LucideIcons.server,
                            l10n.agentCompleteStatus4,
                          ),
                          const SizedBox(height: 10),

                          // Separator
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: const Color(0xFF1F2023),
                          ),
                          const SizedBox(height: 10),

                          // OPTIMIZED FOR label
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              l10n.agentCompleteOptimizedForLabel,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7280),
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Task cards
                          if (tasks.isNotEmpty)
                            ...tasks.map(
                              (task) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _buildCard(_iconForTask(task), task),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom button area
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 16, 32, 48),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () async {
                            HapticFeedback.mediumImpact();
                            ref
                                .read(analyticsProvider)
                                .logOnboardingStepCompleted(
                                  step: 'agent_complete',
                                );
                            await ref
                                .read(secureStorageProvider)
                                .write(
                                  key: 'onboarding_completed',
                                  value: 'true',
                                );
                            ref.read(profileCompletedProvider.notifier).state =
                                true;
                          },
                          child: Text(l10n.commonContinue),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.agentCompleteLiveHint(agentName),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8A8B8D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(IconData icon, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF141415),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1F2023)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF3B82F6)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFFEAEAEB),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static IconData _iconForTask(String task) {
    final lower = task.toLowerCase();
    if (lower.contains('email') || lower.contains('mail')) {
      return LucideIcons.mail;
    }
    if (lower.contains('research')) return LucideIcons.globe;
    if (lower.contains('automation')) return LucideIcons.zap;
    if (lower.contains('schedule') || lower.contains('calendar')) {
      return LucideIcons.calendar;
    }
    if (lower.contains('social')) return LucideIcons.share2;
    if (lower.contains('writ')) return LucideIcons.penTool;
    if (lower.contains('data') || lower.contains('analys')) {
      return LucideIcons.barChart;
    }
    if (lower.contains('home')) return LucideIcons.home;
    return LucideIcons.sparkles;
  }
}
