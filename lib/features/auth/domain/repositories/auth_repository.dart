import '../entities/auth_session.dart';

abstract class AuthRepository {
  Future<String?> getApiKey();

  Future<void> saveApiKey(String apiKey);

  Future<void> clearApiKey();

  Future<bool> validateApiKey(String apiKey);

  Future<AuthSession?> getSession();

  Future<void> saveSession(AuthSession session);

  Future<void> clearSession();

  Future<AuthSession> createSession({
    required String apiKey,
    required String username,
    required String password,
  });

  Future<int?> fetchAccountId({
    required String apiKey,
    required String sessionId,
  });

  Future<String> requireApiKey();
}
