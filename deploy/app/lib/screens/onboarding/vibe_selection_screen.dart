import 'package:clawbox/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../providers/onboarding_provider.dart';
import '../../providers/profile_provider.dart';
import 'widgets/onboarding_scaffold.dart';

class _VibeOption {
  final String name;
  final String description;
  final IconData icon;

  const _VibeOption({
    required this.name,
    required this.description,
    required this.icon,
  });
}

class VibeSelectionScreen extends ConsumerStatefulWidget {
  const VibeSelectionScreen({super.key});

  @override
  ConsumerState<VibeSelectionScreen> createState() =>
      _VibeSelectionScreenState();
}

class _VibeSelectionScreenState extends ConsumerState<VibeSelectionScreen> {
  String? _selectedVibe;

  void _onContinue() {
    if (_selectedVibe == null) return;
    ref.read(profileProvider.notifier).setVibe(_selectedVibe!);
    ref.read(onboardingScreenProvider.notifier).state =
        OnboardingStep.taskSelection;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final vibes = [
      _VibeOption(
        name: l10n.vibeNameCasual,
        description: l10n.vibeDescCasual,
        icon: LucideIcons.smile,
      ),
      _VibeOption(
        name: l10n.vibeNameProfessional,
        description: l10n.vibeDescProfessional,
        icon: LucideIcons.briefcase,
      ),
      _VibeOption(
        name: l10n.vibeNameFriendly,
        description: l10n.vibeDescFriendly,
        icon: LucideIcons.heart,
      ),
      _VibeOption(
        name: l10n.vibeNameDirect,
        description: l10n.vibeDescDirect,
        icon: LucideIcons.zap,
      ),
    ];

    return OnboardingScaffold(
      showBackButton: true,
      onBackPressed: () {
        ref.read(onboardingScreenProvider.notifier).state =
            OnboardingStep.agentCreation;
      },
      buttonText: l10n.commonContinue,
      onButtonPressed: _selectedVibe != null ? _onContinue : null,
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  l10n.vibeSelectionTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEAEAEB),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.vibeSelectionSubtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF8A8B8D),
                  ),
                ),
              ],
            ),
          ),

          // Vibe cards
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  for (int i = 0; i < vibes.length; i++) ...[
                    if (i > 0) const SizedBox(height: 12),
                    Expanded(child: _buildVibeCard(vibes[i])),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVibeCard(_VibeOption vibe) {
    final isSelected = _selectedVibe == vibe.name;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVibe = vibe.name;
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF141415),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3B82F6)
                : const Color(0xFF1F2023),
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(
              vibe.icon,
              size: 28,
              color: isSelected
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFF8A8B8D),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    vibe.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFEAEAEB),
                      fontFamily: 'JetBrains Mono',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    vibe.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8A8B8D),
                      height: 1.4,
                    ),
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
