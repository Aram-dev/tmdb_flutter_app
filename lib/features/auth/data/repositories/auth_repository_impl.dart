import 'package:dio/dio.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/exceptions/auth_exception.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthLocalDataSource localDataSource,
    required AuthRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSource _remoteDataSource;

  String? _cachedApiKey;
  AuthSession? _cachedSession;

  @override
  Future<String?> getApiKey() async {
    if (_cachedApiKey != null) {
      return _cachedApiKey;
    }
    _cachedApiKey = await _localDataSource.getApiKey();
    return _cachedApiKey;
  }

  @override
  Future<void> saveApiKey(String apiKey) async {
    _cachedApiKey = apiKey;
    await _localDataSource.saveApiKey(apiKey);
  }

  @override
  Future<void> clearApiKey() async {
    _cachedApiKey = null;
    await _localDataSource.clearApiKey();
  }

  @override
  Future<bool> validateApiKey(String apiKey) {
    return _remoteDataSource.validateApiKey(apiKey);
  }

  @override
  Future<AuthSession?> getSession() async {
    if (_cachedSession != null) {
      return _cachedSession;
    }
    _cachedSession = await _localDataSource.getSession();
    return _cachedSession;
  }

  @override
  Future<void> saveSession(AuthSession session) async {
    _cachedSession = session;
    await _localDataSource.saveSession(session);
  }

  @override
  Future<void> clearSession() async {
    _cachedSession = null;
    await _localDataSource.clearSession();
  }

  @override
  Future<AuthSession> createSession({
    required String apiKey,
    required String username,
    required String password,
  }) async {
    final tokenResponse = await _remoteDataSource.createRequestToken(apiKey);
    if (!tokenResponse.success || tokenResponse.requestToken.isEmpty) {
      throw AuthException('Failed to create TMDB request token.');
    }

    final validatedToken = await _remoteDataSource.validateWithLogin(
      apiKey: apiKey,
      username: username,
      password: password,
      requestToken: tokenResponse.requestToken,
    );

    if (!validatedToken.success || validatedToken.requestToken.isEmpty) {
      throw AuthException('TMDB credentials are invalid.');
    }

    final sessionResponse = await _remoteDataSource.createSession(
      apiKey: apiKey,
      requestToken: validatedToken.requestToken,
    );

    if (!sessionResponse.success || sessionResponse.sessionId.isEmpty) {
      throw AuthException('Failed to create TMDB session.');
    }

    int? accountId;
    try {
      final account = await _remoteDataSource.fetchAccount(
        apiKey: apiKey,
        sessionId: sessionResponse.sessionId,
      );
      accountId = account.id;
    } on DioException catch (error) {
      if (error.response?.statusCode != 401) {
        rethrow;
      }
    }

    final session = AuthSession(
      sessionId: sessionResponse.sessionId,
      accountId: accountId,
    );
    await saveSession(session);
    return session;
  }

  @override
  Future<int?> fetchAccountId({
    required String apiKey,
    required String sessionId,
  }) async {
    final account = await _remoteDataSource.fetchAccount(
      apiKey: apiKey,
      sessionId: sessionId,
    );
    return account.id;
  }

}
