import 'package:flutter/foundation.dart'
    show kDebugMode, kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../l10n/app_localizations.dart';

class RevenueCatService {
  static Future<void> initialize() async {
    await Purchases.setLogLevel(LogLevel.debug);

    final String apiKey;
    if (kIsWeb) {
      apiKey = kDebugMode ? revenueCatWebSandboxApiKey : revenueCatWebApiKey;
    } else if (kDebugMode) {
      apiKey = revenueCatTestApiKey;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      apiKey = revenueCatAndroidApiKey;
    } else {
      apiKey = revenueCatIosApiKey;
    }

    final configuration = PurchasesConfiguration(apiKey);
    await Purchases.configure(configuration);
  }

  static Future<bool> isProUser() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.all[entitlementId]?.isActive ?? false;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      debugPrint('RevenueCat error checking pro status: $errorCode');
      return false;
    }
  }

  static Future<CustomerInfo> getCustomerInfo() async {
    return await Purchases.getCustomerInfo();
  }

  static Future<Offerings> getOfferings() async {
    return await Purchases.getOfferings();
  }

  static Future<void> showPaywall({BuildContext? context}) async {
    if (kIsWeb && context != null) {
      await _showWebPaywall(context);
    } else if (!kIsWeb) {
      await RevenueCatUI.presentPaywall();
    }
  }

  static Future<void> _showWebPaywall(BuildContext context) async {
    final offerings = await Purchases.getOfferings();
    final current = offerings.current;
    if (current == null || current.availablePackages.isEmpty) return;

    if (!context.mounted) return;
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Paywall',
      barrierColor: Colors.black87,
      pageBuilder: (_, _, _) =>
          _WebPaywallDialog(packages: current.availablePackages),
    );
  }

  static Future<void> showPaywallIfNeeded() async {
    if (kIsWeb) {
      final isActive = await isProUser();
      if (!isActive) {
        await showPaywall();
      }
    } else {
      await RevenueCatUI.presentPaywallIfNeeded(entitlementId);
    }
  }

  static Future<void> showCustomerCenter() async {
    if (kIsWeb) {
      final customerInfo = await Purchases.getCustomerInfo();
      final managementUrl = customerInfo.managementURL;
      if (managementUrl != null) {
        await launchUrl(Uri.parse(managementUrl));
      }
    } else {
      await RevenueCatUI.presentCustomerCenter();
    }
  }

  static void addCustomerInfoListener(void Function(CustomerInfo) listener) {
    Purchases.addCustomerInfoUpdateListener(listener);
  }
}

class _WebPaywallDialog extends StatefulWidget {
  final List<Package> packages;

  const _WebPaywallDialog({required this.packages});

  @override
  State<_WebPaywallDialog> createState() => _WebPaywallDialogState();
}

class _WebPaywallDialogState extends State<_WebPaywallDialog> {
  late int _selectedIndex;
  bool _isPurchasing = false;

  @override
  void initState() {
    super.initState();
    // Default to the best-value package (monthly > annual > first)
    _selectedIndex = widget.packages.indexWhere(
      (p) => p.packageType == PackageType.monthly,
    );
    if (_selectedIndex < 0) _selectedIndex = widget.packages.length - 1;
  }

  String _packageLabel(Package pkg, AppLocalizations l10n) {
    switch (pkg.packageType) {
      case PackageType.weekly:
        return l10n.weekly;
      case PackageType.monthly:
        return l10n.monthly;
      case PackageType.annual:
        return l10n.annual;
      case PackageType.lifetime:
        return l10n.lifetime;
      default:
        return pkg.storeProduct.title;
    }
  }

  String _pricePerPeriod(Package pkg) {
    final price = pkg.storeProduct.priceString;
    switch (pkg.packageType) {
      case PackageType.weekly:
        return '$price/wk';
      case PackageType.monthly:
        return '$price/mo';
      case PackageType.annual:
        return '$price/yr';
      default:
        return price;
    }
  }

  int? _savingsPercent(Package pkg) {
    // Calculate savings compared to weekly
    final weekly = widget.packages
        .where((p) => p.packageType == PackageType.weekly)
        .firstOrNull;
    if (weekly == null || pkg.packageType == PackageType.weekly) return null;

    final weeklyPrice = weekly.storeProduct.price;
    final pkgPrice = pkg.storeProduct.price;

    double weeklyEquivalent;
    switch (pkg.packageType) {
      case PackageType.monthly:
        weeklyEquivalent = weeklyPrice * 4.345; // weeks per month
        break;
      case PackageType.annual:
        weeklyEquivalent = weeklyPrice * 52;
        break;
      default:
        return null;
    }

    final savings = ((weeklyEquivalent - pkgPrice) / weeklyEquivalent * 100)
        .round();
    if (savings <= 0) return null;
    return savings;
  }

  Future<void> _purchase() async {
    if (_isPurchasing) return;
    setState(() => _isPurchasing = true);
    try {
      final package = widget.packages[_selectedIndex];
      final params = PurchaseParams.package(package);
      await Purchases.purchase(params);
      if (mounted) Navigator.of(context).pop();
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('[RC Web] purchase error: $errorCode');
      }
    } finally {
      if (mounted) setState(() => _isPurchasing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Material(
          color: const Color(0xFF0A0A0A),
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Color(0xFFF5F5F5)),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            await Purchases.restorePurchases();
                            if (mounted) Navigator.of(context).pop();
                          } catch (_) {}
                        },
                        child: Text(
                          l10n.restore,
                          style: const TextStyle(
                            color: Color(0xFFF5F5F5),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Title
                  Text(
                    l10n.paywallTitle,
                    style: const TextStyle(
                      color: Color(0xFFF5F5F5),
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Features
                  _FeatureLine(text: l10n.paywallFeature1),
                  const SizedBox(height: 8),
                  _FeatureLine(text: l10n.paywallFeature2),
                  const SizedBox(height: 8),
                  _FeatureLine(text: l10n.paywallFeature3),
                  const SizedBox(height: 24),

                  // Stars + review
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (_) => const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFD700),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '"${l10n.paywallReview}"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFB0B0B0),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '- ${l10n.paywallReviewAuthor}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Package cards
                  for (int i = 0; i < widget.packages.length; i++) ...[
                    _WebPackageCard(
                      label: _packageLabel(widget.packages[i], l10n),
                      price: _pricePerPeriod(widget.packages[i]),
                      savings: _savingsPercent(widget.packages[i]) != null
                          ? l10n.savePercent(
                              _savingsPercent(widget.packages[i])!,
                            )
                          : null,
                      selected: _selectedIndex == i,
                      onTap: () => setState(() => _selectedIndex = i),
                    ),
                    if (i < widget.packages.length - 1)
                      const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 24),

                  // Subscribe button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isPurchasing ? null : _purchase,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5E6A3),
                        foregroundColor: const Color(0xFF1A1A1A),
                        disabledBackgroundColor: const Color(
                          0xFFF5E6A3,
                        ).withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: _isPurchasing
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Color(0xFF1A1A1A),
                              ),
                            )
                          : Text(
                              l10n.subscribe,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Cancel anytime
                  Center(
                    child: Text(
                      l10n.cancelAnytime,
                      style: const TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Footer links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _FooterLink(
                        text: l10n.restorePurchases,
                        onTap: () async {
                          try {
                            await Purchases.restorePurchases();
                            if (mounted) Navigator.of(context).pop();
                          } catch (_) {}
                        },
                      ),
                      const _FooterDot(),
                      _FooterLink(
                        text: l10n.termsOfService,
                        onTap: () =>
                            launchUrl(Uri.parse('$apiBaseUrl/legal/terms')),
                      ),
                      const _FooterDot(),
                      _FooterLink(
                        text: l10n.privacyPolicy,
                        onTap: () =>
                            launchUrl(Uri.parse('$apiBaseUrl/legal/privacy')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureLine extends StatelessWidget {
  final String text;
  const _FeatureLine({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          '\u2022 ',
          style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 16),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFFB0B0B0),
              fontSize: 15,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _WebPackageCard extends StatelessWidget {
  final String label;
  final String price;
  final String? savings;
  final bool selected;
  final VoidCallback onTap;

  const _WebPackageCard({
    required this.label,
    required this.price,
    this.savings,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFF1A1A3E), Color(0xFF0D1B3E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: selected ? null : const Color(0xFF141414),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF4A6CF7) : const Color(0xFF3A3A3A),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFFF5F5F5),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (savings != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      savings!,
                      style: const TextStyle(
                        color: Color(0xFFF5E6A3),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    color: Color(0xFFF5F5F5),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(
                  selected ? Icons.check_circle : Icons.circle_outlined,
                  color: selected
                      ? const Color(0xFF4A6CF7)
                      : const Color(0xFF5A5A5A),
                  size: 22,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _FooterLink({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF6A6A6A), fontSize: 12),
      ),
    );
  }
}

class _FooterDot extends StatelessWidget {
  const _FooterDot();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '\u00B7',
        style: TextStyle(color: Color(0xFF6A6A6A), fontSize: 12),
      ),
    );
  }
}
