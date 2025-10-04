import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/entities/auth_tokens.dart';

class AuthLocalDataSource {
  AuthLocalDataSource({required FlutterSecureStorage storage})
      : _storage = storage;

  final FlutterSecureStorage _storage;

  static const _apiKeyStorageKey = 'tmdb_api_key';
  static const _sessionIdStorageKey = 'tmdb_session_id';
  static const _accountIdStorageKey = 'tmdb_account_id';
  static const _accessTokenStorageKey = 'tmdb_access_token';
  static const _refreshTokenStorageKey = 'tmdb_refresh_token';

  Future<void> saveApiKey(String apiKey) async {
    await _storage.write(key: _apiKeyStorageKey, value: apiKey);
  }

  Future<String?> getApiKey() {
    return _storage.read(key: _apiKeyStorageKey);
  }

  Future<void> clearApiKey() async {
    await _storage.delete(key: _apiKeyStorageKey);
  }

  Future<void> saveSession(AuthSession session) async {
    await _storage.write(key: _sessionIdStorageKey, value: session.sessionId);
    final accountId = session.accountId;
    if (accountId != null) {
      await _storage.write(key: _accountIdStorageKey, value: accountId.toString());
    }
  }

  Future<AuthSession?> getSession() async {
    final sessionId = await _storage.read(key: _sessionIdStorageKey);
    if (sessionId == null || sessionId.isEmpty) {
      return null;
    }
    final accountIdRaw = await _storage.read(key: _accountIdStorageKey);
    final accountId = int.tryParse(accountIdRaw ?? '');
    return AuthSession(sessionId: sessionId, accountId: accountId);
  }

  Future<void> clearSession() async {
    await _storage.delete(key: _sessionIdStorageKey);
    await _storage.delete(key: _accountIdStorageKey);
  }

  Future<void> saveTokens(AuthTokens tokens) async {
    await _storage.write(
      key: _accessTokenStorageKey,
      value: tokens.accessToken,
    );
    await _storage.write(
      key: _refreshTokenStorageKey,
      value: tokens.refreshToken,
    );
  }

  Future<AuthTokens?> getTokens() async {
    final accessToken = await _storage.read(key: _accessTokenStorageKey);
    final refreshToken = await _storage.read(key: _refreshTokenStorageKey);

    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }

    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    return AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenStorageKey);
    await _storage.delete(key: _refreshTokenStorageKey);
  }
}
