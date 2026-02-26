import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/loading_button.dart';
import 'package:clawbox/l10n/app_localizations.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;

  late final AnimationController _orbController;

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.mustAgreeToTerms)),
      );
      return;
    }
    ref
        .read(authProvider.notifier)
        .signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
          name: _nameController.text.trim().isNotEmpty
              ? _nameController.text.trim()
              : null,
        );
  }

  Widget _buildTermsText(BuildContext context, AppLocalizations l10n) {
    const termsMarker = '\u0000TERMS\u0000';
    const privacyMarker = '\u0000PRIVACY\u0000';
    final full = l10n.agreeToTerms(termsMarker, privacyMarker);
    final parts = full.split(RegExp('\u0000(TERMS|PRIVACY)\u0000'));
    final markers = RegExp(
      '\u0000(TERMS|PRIVACY)\u0000',
    ).allMatches(full).map((m) => m.group(1)).toList();

    final spans = <InlineSpan>[];
    int markerIdx = 0;
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(TextSpan(text: parts[i]));
      }
      if (markerIdx < markers.length && i < parts.length - 1) {
        final isTerms = markers[markerIdx] == 'TERMS';
        spans.add(
          TextSpan(
            text: isTerms ? l10n.termsOfService : l10n.privacyPolicy,
            style: TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchUrl(
                  Uri.parse(
                    '$apiBaseUrl/legal/${isTerms ? 'terms' : 'privacy'}',
                  ),
                  mode: LaunchMode.externalApplication,
                );
              },
          ),
        );
        markerIdx++;
      }
    }

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodySmall,
        children: spans,
      ),
    );
  }

  Widget _buildSignupForm(
    BuildContext context,
    AppLocalizations l10n,
    AuthState authState,
    bool isLoading,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
                    authState.error!,
                    style: TextStyle(color: AppColors.error, fontSize: 13),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: l10n.nameOptional,
                  prefixIcon: const Icon(Icons.person_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: l10n.email,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.invalidEmail;
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                    return l10n.invalidEmail;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: l10n.password,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return l10n.passwordTooShort;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  hintText: l10n.confirmPassword,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return l10n.passwordsDoNotMatch;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: _agreedToTerms,
                onChanged: (value) {
                  setState(() {
                    _agreedToTerms = value ?? false;
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: _buildTermsText(context, l10n)),
          ],
        ),
        const SizedBox(height: 16),
        LoadingButton(
          onPressed: _submit,
          isLoading: isLoading,
          label: Text(l10n.signUp),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.alreadyHaveAccount,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => context.go('/auth'),
              child: Text(
                l10n.logIn,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 720;

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            // Left brand panel
            Expanded(
              flex: width >= 1080 ? 5 : 4,
              child: _SignupBrandPanel(
                orbController: _orbController,
                title: l10n.signUp,
                subtitle: l10n.signUpSubtitle,
              ),
            ),
            // Right form panel
            Expanded(
              flex: width >= 1080 ? 4 : 5,
              child: Container(
                color: AppColors.background,
                child: SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 48,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.signUp,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.signUpSubtitle,
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildSignupForm(
                              context,
                              l10n,
                              authState,
                              isLoading,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Mobile layout
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 48),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 80,
                    height: 80,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.signUp,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.signUpSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _buildSignupForm(context, l10n, authState, isLoading),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Brand panel for signup screen
// ---------------------------------------------------------------------------
class _SignupBrandPanel extends StatelessWidget {
  final AnimationController orbController;
  final String title;
  final String subtitle;

  const _SignupBrandPanel({
    required this.orbController,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF050508)),
      child: Stack(
        children: [
          // Animated gradient orbs
          AnimatedBuilder(
            animation: orbController,
            builder: (context, child) {
              final t = orbController.value;
              return Stack(
                children: [
                  Positioned(
                    left: -60 + 40 * math.sin(t * math.pi),
                    top: -40 + 30 * math.cos(t * math.pi * 0.7),
                    child: _GlowOrb(
                      size: 320,
                      color: GlassColors.orbCyan.withValues(alpha: 0.12),
                    ),
                  ),
                  Positioned(
                    right: -80 + 50 * math.cos(t * math.pi * 1.3),
                    bottom: -60 + 40 * math.sin(t * math.pi * 0.5),
                    child: _GlowOrb(
                      size: 280,
                      color: GlassColors.orbPurple.withValues(alpha: 0.10),
                    ),
                  ),
                  Positioned(
                    right: 60 + 30 * math.sin(t * math.pi * 0.9),
                    top: 100 + 20 * math.cos(t * math.pi * 1.1),
                    child: _GlowOrb(
                      size: 180,
                      color: GlassColors.orbTeal.withValues(alpha: 0.08),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 48,
                          height: 48,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'ClawBox',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                  const Spacer(flex: 3),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -1.0,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(flex: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;
  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0.0)]),
      ),
    );
  }
}
