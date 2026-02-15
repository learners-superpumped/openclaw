import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'package:clawbox/l10n/app_localizations.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset('assets/images/logo.png', width: 80, height: 80),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.login,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context)!.loginSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              if (authState.error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: AppColors.error, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          authState.error ?? AppLocalizations.of(context)!.loginFailed,
                          style: TextStyle(color: AppColors.error, fontSize: 13),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              FilledButton.icon(
                onPressed: isLoading ? null : () => ref.read(authProvider.notifier).signInWithGoogle(),
                icon: isLoading ? const SizedBox.shrink() : const Icon(Icons.g_mobiledata, size: 24),
                label: isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(AppLocalizations.of(context)!.continueWithGoogle),
              ),
              if (Platform.isIOS || Platform.isMacOS) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: isLoading ? null : () => ref.read(authProvider.notifier).signInWithApple(),
                  icon: const Icon(Icons.apple, size: 24),
                  label: Text(AppLocalizations.of(context)!.continueWithApple),
                ),
              ],
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
