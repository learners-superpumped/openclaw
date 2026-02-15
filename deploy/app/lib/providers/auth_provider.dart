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
      if (subNotifier.isPromo) {
        final promoCode = await subNotifier.getPromoCode();
        if (promoCode != null) {
          try { await apiClient.activatePromo(promoCode); } catch (_) {}
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
      if (subNotifier.isPromo) {
        final promoCode = await subNotifier.getPromoCode();
        if (promoCode != null) {
          try { await apiClient.activatePromo(promoCode); } catch (_) {}
        }
      }
      _ref.read(instanceProvider.notifier).resetState();
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = AuthState(status: AuthStatus.error, error: e.toString());
    }
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
