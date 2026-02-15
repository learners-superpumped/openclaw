import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/revenue_cat_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RevenueCatService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClawBox',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}
