import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../constants.dart';
import '../models/auth_tokens.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage;

  AuthService(this._apiClient, this._storage);

  Future<AuthTokens> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      serverClientId: googleServerClientId,
    );
    final account = await googleSignIn.signIn();
    if (account == null) {
      throw Exception('Google sign-in cancelled');
    }

    final authentication = await account.authentication;
    final idToken = authentication.idToken;
    if (idToken == null) {
      throw Exception('Failed to get Google ID token');
    }

    final tokens = await _apiClient.googleLogin(idToken);
    await _saveTokens(tokens);
    return tokens;
  }

  Future<AuthTokens> signInWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final identityToken = credential.identityToken;
    if (identityToken == null) {
      throw Exception('Failed to get Apple identity token');
    }

    final tokens = await _apiClient.appleLogin(
      identityToken,
      givenName: credential.givenName,
      familyName: credential.familyName,
    );
    await _saveTokens(tokens);
    return tokens;
  }

  Future<AuthTokens> signInWithEmail(String email, String password) async {
    final tokens = await _apiClient.emailLogin(email, password);
    await _saveTokens(tokens);
    return tokens;
  }

  Future<AuthTokens> signUpWithEmail(String email, String password, {String? name}) async {
    final tokens = await _apiClient.emailSignup(email, password, name: name);
    await _saveTokens(tokens);
    return tokens;
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
  }

  Future<void> signOut() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  bool get isAppleSignInAvailable => Platform.isIOS || Platform.isMacOS;

  Future<void> _saveTokens(AuthTokens tokens) async {
    await _storage.write(key: 'access_token', value: tokens.accessToken);
    await _storage.write(key: 'refresh_token', value: tokens.refreshToken);
  }
}
