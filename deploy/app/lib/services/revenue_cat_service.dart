import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../constants.dart';

class RevenueCatService {
  static Future<void> initialize() async {
    await Purchases.setLogLevel(LogLevel.debug);

    final String apiKey;
    if (kDebugMode) {
      apiKey = revenueCatTestApiKey;
    } else if (Platform.isAndroid) {
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

  static Future<void> showPaywall() async {
    await RevenueCatUI.presentPaywall();
  }

  static Future<void> showPaywallIfNeeded() async {
    await RevenueCatUI.presentPaywallIfNeeded(entitlementId);
  }

  static Future<void> showCustomerCenter() async {
    await RevenueCatUI.presentCustomerCenter();
  }

  static void addCustomerInfoListener(void Function(CustomerInfo) listener) {
    Purchases.addCustomerInfoUpdateListener(listener);
  }
}
