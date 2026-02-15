import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/branded_logo_loader.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: BrandedLogoLoader(animate: true, showProgressBar: true),
      ),
    );
  }
}
