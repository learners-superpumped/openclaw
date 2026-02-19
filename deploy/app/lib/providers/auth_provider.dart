import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../models/user.dart';
import 'api_provider.dart';
import 'instance_provider.dart';
import 'subscription_provider.dart';

enum AuthStatus { unauthenticated, loading, authenticated, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.user,
    this.error,
  });

  AuthState copyWith({AuthStatus? status, User? user, String? error}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AuthState());

  Future<void> checkAuth() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final authService = _ref.read(authServiceProvider);
      final isAuth = await authService.isAuthenticated();
      if (isAuth) {
        final apiClient = _ref.read(apiClientProvider);
        final user = await apiClient.getMe();
        state = AuthState(status: AuthStatus.authenticated, user: user);
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = AuthState(status: AuthStatus.error, error: e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final authService = _ref.read(authServiceProvider);
      await authService.signInWithGoogle();
      final apiClient = _ref.read(apiClientProvider);
      final user = await apiClient.getMe();
      await Purchases.logIn(user.id);
      final subNotifier = _ref.read(isProProvider.notifier);
      if (subNotifier.isReferral) {
        final referralCode = await subNotifier.getReferralCode();
        if (referralCode != null) {
          try { await apiClient.activateReferral(referralCode); } catch (_) {}
        }
      }
      _ref.read(instanceProvider.notifier).resetState();
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = AuthState(status: AuthStatus.error, error: e.toString());
    }
  }

  Future<void> signInWithApple() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final authService = _ref.read(authServiceProvider);
      await authService.signInWithApple();
      final apiClient = _ref.read(apiClientProvider);
      final user = await apiClient.getMe();
      await Purchases.logIn(user.id);
      final subNotifier = _ref.read(isProProvider.notifier);
      if (subNotifier.isReferral) {
        final referralCode = await subNotifier.getReferralCode();
        if (referralCode != null) {
          try { await apiClient.activateReferral(referralCode); } catch (_) {}
        }
      }
      _ref.read(instanceProvider.notifier).resetState();
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = AuthState(status: AuthStatus.error, error: e.toString());
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final authService = _ref.read(authServiceProvider);
      await authService.signInWithEmail(email, password);
      final apiClient = _ref.read(apiClientProvider);
      final user = await apiClient.getMe();
      await Purchases.logIn(user.id);
      final subNotifier = _ref.read(isProProvider.notifier);
      if (subNotifier.isReferral) {
        final referralCode = await subNotifier.getReferralCode();
        if (referralCode != null) {
          try { await apiClient.activateReferral(referralCode); } catch (_) {}
        }
      }
      _ref.read(instanceProvider.notifier).resetState();
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = AuthState(status: AuthStatus.error, error: _parseError(e));
    }
  }

  Future<void> signUpWithEmail(String email, String password, {String? name}) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final authService = _ref.read(authServiceProvider);
      await authService.signUpWithEmail(email, password, name: name);
      final apiClient = _ref.read(apiClientProvider);
      final user = await apiClient.getMe();
      await Purchases.logIn(user.id);
      final subNotifier = _ref.read(isProProvider.notifier);
      if (subNotifier.isReferral) {
        final referralCode = await subNotifier.getReferralCode();
        if (referralCode != null) {
          try { await apiClient.activateReferral(referralCode); } catch (_) {}
        }
      }
      _ref.read(instanceProvider.notifier).resetState();
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = AuthState(status: AuthStatus.error, error: _parseError(e));
    }
  }

  String _parseError(Object e) {
    if (e is DioException && e.response != null) {
      final statusCode = e.response!.statusCode;
      final data = e.response!.data;
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        final message = data['message'];
        if (message is String) return message;
        if (message is List) return message.join(', ');
      }
      if (statusCode == 409) return 'This email is already registered.';
      if (statusCode == 401) return 'Invalid email or password.';
    }
    return e.toString();
  }

  Future<void> signOut() async {
    final authService = _ref.read(authServiceProvider);
    await authService.signOut();
    _ref.read(instanceProvider.notifier).resetState();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> deleteAccount() async {
    final apiClient = _ref.read(apiClientProvider);
    await apiClient.deleteAccount();
    await Purchases.logOut();
    final authService = _ref.read(authServiceProvider);
    await authService.signOut();
    _ref.read(instanceProvider.notifier).resetState();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
