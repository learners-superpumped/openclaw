import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/onboarding_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/main_shell.dart';
import 'screens/skill_detail_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/instance_loading_screen.dart';
import 'screens/onboarding_shell.dart';
import 'screens/paywall_screen.dart';
import 'screens/setup_complete_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/telegram_pairing_screen.dart';
import 'screens/telegram_setup_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final step = ref.watch(onboardingStepProvider);

  return GoRouter(
    initialLocation: _locationForStep(step),
    redirect: (context, state) {
      final target = _locationForStep(step);
      final currentPath = state.uri.toString();
      if (step == OnboardingStep.auth && currentPath.startsWith('/auth')) {
        return null;
      }
      if (step == OnboardingStep.dashboard && currentPath.startsWith('/dashboard')) {
        return null;
      }
      if (currentPath != target) {
        return target;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/paywall',
        builder: (context, state) => const PaywallScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
        routes: [
          GoRoute(
            path: 'signup',
            builder: (context, state) => const SignupScreen(),
          ),
        ],
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
          GoRoute(
            path: '/setup/complete',
            builder: (context, state) => const SetupCompleteScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const MainShell(),
        routes: [
          GoRoute(
            path: 'chat',
            builder: (context, state) => const ChatScreen(),
          ),
          GoRoute(
            path: 'skills/:slug',
            builder: (context, state) => SkillDetailScreen(
              slug: state.pathParameters['slug']!,
            ),
          ),
          GoRoute(
            path: 'connect-telegram',
            builder: (context, state) {
              final router = GoRouter.of(context);
              return Scaffold(
                appBar: AppBar(),
                body: TelegramSetupScreen(
                  onTokenSubmitted: () async {
                    await router.push('/dashboard/connect-telegram/pairing');
                    if (context.mounted) router.pop();
                  },
                  onSkipped: () => router.pop(),
                ),
              );
            },
            routes: [
              GoRoute(
                path: 'pairing',
                builder: (context, state) => Scaffold(
                  appBar: AppBar(),
                  body: TelegramPairingScreen(
                    onPairingComplete: () => GoRouter.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

String _locationForStep(OnboardingStep step) {
  switch (step) {
    case OnboardingStep.initializing:
      return '/splash';
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
    case OnboardingStep.setupComplete:
      return '/setup/complete';
    case OnboardingStep.dashboard:
      return '/dashboard';
  }
}
