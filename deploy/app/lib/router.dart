import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/onboarding_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/instance_loading_screen.dart';
import 'screens/onboarding_shell.dart';
import 'screens/paywall_screen.dart';
import 'screens/telegram_pairing_screen.dart';
import 'screens/telegram_setup_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final step = ref.watch(onboardingStepProvider);

  return GoRouter(
    initialLocation: _locationForStep(step),
    redirect: (context, state) {
      final target = _locationForStep(step);
      if (state.uri.toString() != target) {
        return target;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/paywall',
        builder: (context, state) => const PaywallScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => OnboardingShell(child: child),
        routes: [
          GoRoute(
            path: '/setup/loading',
            builder: (context, state) => const InstanceLoadingScreen(),
          ),
          GoRoute(
            path: '/setup/telegram',
            builder: (context, state) => const TelegramSetupScreen(),
          ),
          GoRoute(
            path: '/setup/pairing',
            builder: (context, state) => const TelegramPairingScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
});

String _locationForStep(OnboardingStep step) {
  switch (step) {
    case OnboardingStep.paywall:
      return '/paywall';
    case OnboardingStep.auth:
      return '/auth';
    case OnboardingStep.instanceLoading:
      return '/setup/loading';
    case OnboardingStep.telegramSetup:
      return '/setup/telegram';
    case OnboardingStep.telegramPairing:
      return '/setup/pairing';
    case OnboardingStep.dashboard:
      return '/dashboard';
  }
}
