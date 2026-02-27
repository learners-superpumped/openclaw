import 'package:clawbox/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/api_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../providers/profile_provider.dart';
import 'widgets/onboarding_scaffold.dart';

class _CreatureOption {
  final String key;
  final String label;
  final String emoji;

  const _CreatureOption({
    required this.key,
    required this.label,
    required this.emoji,
  });
}

const _creatureEmojis = {
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

List<_CreatureOption> _buildCreatures(AppLocalizations l10n) => [
  _CreatureOption(
    key: 'cat',
    label: l10n.creatureCat,
    emoji: _creatureEmojis['cat']!,
  ),
  _CreatureOption(
    key: 'dragon',
    label: l10n.creatureDragon,
    emoji: _creatureEmojis['dragon']!,
  ),
  _CreatureOption(
    key: 'fox',
    label: l10n.creatureFox,
    emoji: _creatureEmojis['fox']!,
  ),
  _CreatureOption(
    key: 'owl',
    label: l10n.creatureOwl,
    emoji: _creatureEmojis['owl']!,
  ),
  _CreatureOption(
    key: 'rabbit',
    label: l10n.creatureRabbit,
    emoji: _creatureEmojis['rabbit']!,
  ),
  _CreatureOption(
    key: 'bear',
    label: l10n.creatureBear,
    emoji: _creatureEmojis['bear']!,
  ),
  _CreatureOption(
    key: 'dino',
    label: l10n.creatureDino,
    emoji: _creatureEmojis['dino']!,
  ),
  _CreatureOption(
    key: 'penguin',
    label: l10n.creaturePenguin,
    emoji: _creatureEmojis['penguin']!,
  ),
  _CreatureOption(
    key: 'person',
    label: l10n.creaturePerson,
    emoji: _creatureEmojis['person']!,
  ),
  _CreatureOption(
    key: 'wolf',
    label: l10n.creatureWolf,
    emoji: _creatureEmojis['wolf']!,
  ),
  _CreatureOption(
    key: 'panda',
    label: l10n.creaturePanda,
    emoji: _creatureEmojis['panda']!,
  ),
  _CreatureOption(
    key: 'unicorn',
    label: l10n.creatureUnicorn,
    emoji: _creatureEmojis['unicorn']!,
  ),
];

const _agentEmojis = [
  '\u{1F916}', // robot
  '\u{26A1}', // lightning
  '\u{1F680}', // rocket
  '\u{2B50}', // star
  '\u{1F525}', // fire
  '\u{1F9E0}', // brain
  '\u{1F30D}', // globe
  '\u{2728}', // sparkles
  '\u{1F451}', // crown
  '\u{1F48E}', // gem
  '\u{2764}\u{FE0F}', // heart
  '\u{1F6E1}\u{FE0F}', // shield
];

class AgentCreationScreen extends ConsumerStatefulWidget {
  const AgentCreationScreen({super.key});

  @override
  ConsumerState<AgentCreationScreen> createState() =>
      _AgentCreationScreenState();
}

class _AgentCreationScreenState extends ConsumerState<AgentCreationScreen> {
  late final TextEditingController _agentNameController;
  String? _selectedCreature;
  String? _selectedEmoji;

  @override
  void initState() {
    super.initState();
    _agentNameController = TextEditingController();
    _agentNameController.addListener(_onChanged);
    ref.read(analyticsProvider).logOnboardingStepViewed(step: 'agent_creation');
  }

  void _onChanged() => setState(() {});

  @override
  void dispose() {
    _agentNameController.dispose();
    super.dispose();
  }

  bool get _isValid => _agentNameController.text.trim().isNotEmpty;

  void _onContinue() {
    HapticFeedback.lightImpact();
    ref
        .read(analyticsProvider)
        .logOnboardingStepCompleted(step: 'agent_creation');
    if (!_isValid) return;
    ref
        .read(profileProvider.notifier)
        .setAgentCreation(
          agentName: _agentNameController.text.trim(),
          creature: _selectedCreature,
          agentEmoji: _selectedEmoji,
        );
    ref.read(onboardingScreenProvider.notifier).state =
        OnboardingStep.vibeSelection;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final creatures = _buildCreatures(l10n);

    return OnboardingScaffold(
      showBackButton: true,
      onBackPressed: () {
        HapticFeedback.lightImpact();
        ref
            .read(analyticsProvider)
            .logOnboardingBackTapped(fromStep: 'agent_creation');
        ref.read(onboardingScreenProvider.notifier).state =
            OnboardingStep.userProfile;
      },
      buttonText: l10n.commonContinue,
      onButtonPressed: _isValid ? _onContinue : null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  Text(
                    l10n.agentCreationTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFEAEAEB),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.agentCreationSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8A8B8D),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Content area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Agent Name label
                  Text(
                    l10n.agentCreationNameLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFEAEAEB),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 40,
                    child: TextField(
                      controller: _agentNameController,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFEAEAEB),
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.agentCreationNameHint,
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8A8B8D),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF0A0A0B),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide: const BorderSide(
                            color: Color(0xFF2E2E2E),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide: const BorderSide(
                            color: Color(0xFF2E2E2E),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide: const BorderSide(
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Creature Type label
                  Text(
                    l10n.agentCreationCreatureLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFEAEAEB),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Creature grid — 4 columns x 3 rows
                  _buildCreatureGrid(creatures),

                  const SizedBox(height: 16),

                  // Agent Emoji label
                  Text(
                    l10n.agentCreationEmojiLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFEAEAEB),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Emoji grid — 6 columns x 2 rows
                  _buildEmojiGrid(),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatureGrid(List<_CreatureOption> creatures) {
    return Column(
      children: [
        for (int row = 0; row < 3; row++) ...[
          if (row > 0) const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int col = 0; col < 4; col++) ...[
                if (col > 0) const SizedBox(width: 10),
                _buildCreatureCard(creatures[row * 4 + col]),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCreatureCard(_CreatureOption creature) {
    final isSelected = _selectedCreature == creature.key;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedCreature = isSelected ? null : creature.key;
        });
        if (!isSelected) {
          ref
              .read(analyticsProvider)
              .logOnboardingCreatureSelected(creature: creature.key);
        }
      },
      child: Container(
        width: 75,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3B82F6)
                : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(creature.emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 4),
            Text(
              creature.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiGrid() {
    return Column(
      children: [
        for (int row = 0; row < 2; row++) ...[
          if (row > 0) const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int col = 0; col < 6; col++) ...[
                if (col > 0) const SizedBox(width: 10),
                _buildEmojiCard(_agentEmojis[row * 6 + col]),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildEmojiCard(String emoji) {
    final isSelected = _selectedEmoji == emoji;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedEmoji = isSelected ? null : emoji;
        });
        if (!isSelected) {
          ref.read(analyticsProvider).logOnboardingEmojiSelected(emoji: emoji);
        }
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3B82F6)
                : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
      ),
    );
  }
}
