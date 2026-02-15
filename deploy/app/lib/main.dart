import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/auth_provider.dart';
import 'providers/instance_provider.dart';
import 'router.dart';
import 'services/revenue_cat_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    Future.microtask(() {
      ref.read(authProvider.notifier).checkAuth();
      ref.read(instanceProvider.notifier).loadExisting();
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
    );
  }
}
