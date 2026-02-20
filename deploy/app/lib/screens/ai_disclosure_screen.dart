import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../l10n/app_localizations.dart';
import '../providers/api_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/onboarding_provider.dart';
import '../theme/app_theme.dart';

class AiDisclosureScreen extends ConsumerWidget {
  const AiDisclosureScreen({super.key});

  static const _consentKey = 'ai_data_consent_accepted';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 32),
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: AppColors.accent,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.aiDataProcessing,
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _SectionTitle(title: l10n.aiConsentDataSentTitle),
                  const SizedBox(height: 8),
                  _BulletItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    text: l10n.aiConsentDataSentMessages,
                  ),
                  _BulletItem(
                    icon: Icons.image_outlined,
                    text: l10n.aiConsentDataSentImages,
                  ),
                  _BulletItem(
                    icon: Icons.history_rounded,
                    text: l10n.aiConsentDataSentContext,
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(title: l10n.aiConsentRecipientsTitle),
                  const SizedBox(height: 8),
                  _BulletItem(
                    icon: Icons.router_outlined,
                    text: l10n.aiConsentRecipientOpenRouter,
                  ),
                  _BulletItem(
                    icon: Icons.auto_awesome_outlined,
                    text: l10n.aiConsentRecipientProviders,
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(title: l10n.aiConsentUsageTitle),
                  const SizedBox(height: 8),
                  _BulletItem(
                    icon: Icons.check_circle_outline_rounded,
                    text: l10n.aiConsentUsageResponses,
                  ),
                  _BulletItem(
                    icon: Icons.block_rounded,
                    text: l10n.aiConsentUsageNoTraining,
                  ),
                  _BulletItem(
                    icon: Icons.delete_outline_rounded,
                    text: l10n.aiConsentUsageDeletion,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => launchUrl(
                      Uri.parse('$apiBaseUrl/legal/privacy'),
                      mode: LaunchMode.externalApplication,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.open_in_new_rounded,
                          size: 16,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.aiConsentViewPrivacy,
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  FilledButton(
                    onPressed: () async {
                      final storage = ref.read(secureStorageProvider);
                      await storage.write(key: _consentKey, value: 'true');
                      ref.read(aiDisclosureAcceptedProvider.notifier).state =
                          true;
                    },
                    child: Text(l10n.aiDisclosureAgree),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      ref.read(authProvider.notifier).signOut();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.aiConsentRequired)),
                      );
                    },
                    child: Text(
                      l10n.decline,
                      style: TextStyle(color: AppColors.textSecondary),
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

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _BulletItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textTertiary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
