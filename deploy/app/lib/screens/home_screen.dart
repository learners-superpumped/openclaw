import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../constants.dart';
import '../services/revenue_cat_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isPro = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkProStatus();
    RevenueCatService.addCustomerInfoListener(_onCustomerInfoUpdated);
  }

  void _onCustomerInfoUpdated(CustomerInfo customerInfo) {
    final isPro =
        customerInfo.entitlements.all[entitlementId]?.isActive ?? false;
    if (mounted) {
      setState(() => _isPro = isPro);
    }
  }

  Future<void> _checkProStatus() async {
    final isPro = await RevenueCatService.isProUser();
    if (mounted) {
      setState(() {
        _isPro = isPro;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClawBox'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isPro ? Icons.star : Icons.star_border,
                    size: 64,
                    color: _isPro ? Colors.amber : Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isPro ? 'ClawBox Pro' : 'ClawBox Free',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),
                  if (!_isPro)
                    FilledButton.icon(
                      onPressed: () => RevenueCatService.showPaywall(),
                      icon: const Icon(Icons.rocket_launch),
                      label: const Text('구독하기'),
                    ),
                  if (_isPro) ...[
                    FilledButton.icon(
                      onPressed: () =>
                          RevenueCatService.showCustomerCenter(),
                      icon: const Icon(Icons.manage_accounts),
                      label: const Text('구독 관리'),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
