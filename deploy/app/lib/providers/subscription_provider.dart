import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../constants.dart';

class SubscriptionNotifier extends StateNotifier<bool> {
  StreamSubscription<CustomerInfo>? _subscription;
  final Completer<void> _initCompleter = Completer<void>();

  Future<void> get initialized => _initCompleter.future;

  SubscriptionNotifier() : super(false) {
    _init();
  }

  Future<void> _init() async {
    try {
      final info = await Purchases.getCustomerInfo();
      state = info.entitlements.all[entitlementId]?.isActive ?? false;
    } catch (_) {}

    _initCompleter.complete();
    Purchases.addCustomerInfoUpdateListener(_onUpdate);
  }

  void _onUpdate(CustomerInfo info) {
    state = info.entitlements.all[entitlementId]?.isActive ?? false;
  }

  Future<void> refresh() async {
    try {
      final info = await Purchases.getCustomerInfo();
      state = info.entitlements.all[entitlementId]?.isActive ?? false;
    } catch (_) {}
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final isProProvider = StateNotifierProvider<SubscriptionNotifier, bool>((ref) {
  return SubscriptionNotifier();
});
