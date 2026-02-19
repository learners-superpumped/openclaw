import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../constants.dart';
import 'api_provider.dart';

class SubscriptionNotifier extends StateNotifier<bool> {
  StreamSubscription<CustomerInfo>? _subscription;
  final Completer<void> _initCompleter = Completer<void>();
  final FlutterSecureStorage _storage;
  bool _isReferral = false;

  Future<void> get initialized => _initCompleter.future;

  bool get isReferral => _isReferral;

  Future<String?> getReferralCode() => _storage.read(key: 'referral_code');

  SubscriptionNotifier(this._storage) : super(false) {
    _init();
  }

  Future<void> _init() async {
    bool revenueCatActive = false;
    try {
      final info = await Purchases.getCustomerInfo();
      revenueCatActive = info.entitlements.all[entitlementId]?.isActive ?? false;
    } catch (_) {}

    final referralValue = await _storage.read(key: 'is_referral_user');
    _isReferral = referralValue == 'true';

    state = revenueCatActive || _isReferral;
    _initCompleter.complete();
    Purchases.addCustomerInfoUpdateListener(_onUpdate);
  }

  void _onUpdate(CustomerInfo info) {
    final revenueCatActive = info.entitlements.all[entitlementId]?.isActive ?? false;
    state = revenueCatActive || _isReferral;
  }

  Future<void> refresh() async {
    bool revenueCatActive = false;
    try {
      final info = await Purchases.getCustomerInfo();
      revenueCatActive = info.entitlements.all[entitlementId]?.isActive ?? false;
    } catch (_) {}

    final referralValue = await _storage.read(key: 'is_referral_user');
    _isReferral = referralValue == 'true';

    state = revenueCatActive || _isReferral;
  }

  Future<void> activateReferral(String code) async {
    await _storage.write(key: 'is_referral_user', value: 'true');
    await _storage.write(key: 'referral_code', value: code);
    _isReferral = true;
    state = true;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final isProProvider = StateNotifierProvider<SubscriptionNotifier, bool>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return SubscriptionNotifier(storage);
});
