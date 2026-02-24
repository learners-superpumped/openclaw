import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:purchases_flutter/purchases_flutter.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'providers/api_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/instance_provider.dart';
import 'providers/onboarding_provider.dart';
import 'providers/subscription_provider.dart';
import 'router.dart';
import 'services/revenue_cat_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await RevenueCatService.initialize();
  runApp(const ProviderScope(child: ClawBoxApp()));
}

class ClawBoxApp extends ConsumerStatefulWidget {
  const ClawBoxApp({super.key});

  @override
  ConsumerState<ClawBoxApp> createState() => _ClawBoxAppState();
}

class _ClawBoxAppState extends ConsumerState<ClawBoxApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await Future.wait([
        ref.read(authProvider.notifier).checkAuth(),
        ref.read(isProProvider.notifier).initialized,
      ]);

      if (ref.read(authProvider).status == AuthStatus.authenticated) {
        try {
          await Purchases.logIn(ref.read(authProvider).user!.id);
          await ref.read(isProProvider.notifier).refresh();
        } catch (_) {}
        await ref.read(instanceProvider.notifier).loadExisting();
      }

      final storage = ref.read(secureStorageProvider);
      final consent = await storage.read(key: 'ai_data_consent_v2');
      if (consent == 'true') {
        ref.read(aiDisclosureAcceptedProvider.notifier).state = true;
      }

      ref.read(appInitializedProvider.notifier).state = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'ClawBox',
      theme: AppTheme.dark,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
