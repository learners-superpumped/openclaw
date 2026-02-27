import 'package:flutter/material.dart';

class OnboardingScaffold extends StatelessWidget {
  final Widget body;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool showLogo;
  final Widget? bottomWidget;

  const OnboardingScaffold({
    super.key,
    required this.body,
    this.buttonText,
    this.onButtonPressed,
    this.showBackButton = false,
    this.onBackPressed,
    this.showLogo = true,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0B),
      body: Stack(
        children: [
          // Hexgrid background
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding/hexgrid-v3.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                // Top bar with optional back button and logo
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: SizedBox(
                    height: 36,
                    child: Row(
                      children: [
                        if (showBackButton)
                          GestureDetector(
                            onTap: onBackPressed,
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Color(0xFFEAEAEB),
                              size: 20,
                            ),
                          )
                        else
                          const SizedBox(width: 20),
                        if (showLogo) ...[
                          const Expanded(
                            child: Center(
                              child: Text(
                                'ClawBox',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFEAEAEB),
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                        ] else
                          const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                ),
                // Body
                Expanded(child: body),
                // Bottom button area
                if (buttonText != null || bottomWidget != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 48),
                    child:
                        bottomWidget ??
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton(
                            onPressed: onButtonPressed,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF3B82F6),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            child: Text(buttonText!),
                          ),
                        ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
