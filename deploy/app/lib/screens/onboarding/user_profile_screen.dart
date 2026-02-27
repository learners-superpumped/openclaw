import 'package:clawbox/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/onboarding_provider.dart';
import '../../providers/profile_provider.dart';
import 'widgets/onboarding_scaffold.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _callNameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _callNameController = TextEditingController();
    _nameController.addListener(_onChanged);
    _callNameController.addListener(_onChanged);
  }

  void _onChanged() => setState(() {});

  @override
  void dispose() {
    _nameController.dispose();
    _callNameController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty &&
      _callNameController.text.trim().isNotEmpty;

  void _onContinue() {
    if (!_isValid) return;
    ref
        .read(profileProvider.notifier)
        .setUserProfile(
          userName: _nameController.text.trim(),
          callName: _callNameController.text.trim(),
        );
    ref.read(onboardingScreenProvider.notifier).state =
        OnboardingStep.agentCreation;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return OnboardingScaffold(
      showBackButton: true,
      onBackPressed: () {
        ref.read(onboardingScreenProvider.notifier).state =
            OnboardingStep.welcomeLanding;
      },
      buttonText: l10n.commonContinue,
      onButtonPressed: _isValid ? _onContinue : null,
      body: Column(
        children: [
          // Header section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  l10n.userProfileTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEAEAEB),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.userProfileSubtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF8A8B8D),
                  ),
                ),
              ],
            ),
          ),

          // Input area — centered vertically in remaining space
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name field
                  Text(
                    l10n.userProfileNameLabel,
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
                      controller: _nameController,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFEAEAEB),
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.userProfileNameHint,
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
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Call name field
                  Text(
                    l10n.userProfileCallNameLabel,
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
                      controller: _callNameController,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFEAEAEB),
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.userProfileCallNameHint,
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
                      onSubmitted: (_) {
                        if (_isValid) _onContinue();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
