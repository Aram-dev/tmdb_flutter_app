import 'package:dio/dio.dart';

import '../../domain/entities/auth_tokens.dart';
import '../models/account_response.dart';
import '../models/request_token_response.dart';
import '../models/session_response.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<bool> validateApiKey(String apiKey) async {
    try {
      final response = await _dio.get(
        '/configuration',
        options: _withAuthorization(apiKey),
      );
      return response.statusCode == 200;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        return false;
      }
      rethrow;
    }
  }

  Future<RequestTokenResponse> createRequestToken(String apiKey) async {
    final response = await _dio.get(
      '/authentication/token/new',
      options: _withAuthorization(apiKey),
    );
    return RequestTokenResponse.fromJson(_mapResponse(response.data));
  }

  Future<RequestTokenResponse> validateWithLogin({
    required String apiKey,
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final response = await _dio.post(
      '/authentication/token/validate_with_login',
      data: {
        'username': username,
        'password': password,
        'request_token': requestToken,
      },
      options: _withAuthorization(apiKey),
    );
    return RequestTokenResponse.fromJson(_mapResponse(response.data));
  }

  Future<SessionResponse> createSession({
    required String apiKey,
    required String requestToken,
  }) async {
    final response = await _dio.post(
      '/authentication/session/new',
      data: {'request_token': requestToken},
      options: _withAuthorization(apiKey),
    );
    return SessionResponse.fromJson(_mapResponse(response.data));
  }

  Future<AccountResponse> fetchAccount({
    required String apiKey,
    required String sessionId,
  }) async {
    final response = await _dio.get(
      '/account',
      queryParameters: {
        'session_id': sessionId,
      },
      options: _withAuthorization(apiKey),
    );
    return AccountResponse.fromJson(_mapResponse(response.data));
  }

  Future<AuthTokens?> refreshTokens({required String refreshToken}) async {
    try {
      final response = await _dio.post(
        '/authentication/token/refresh',
        data: {
          'refresh_token': refreshToken,
        },
      );
      final data = _mapResponse(response.data);
      final accessToken = data['access_token'] as String? ?? '';
      final newRefreshToken = data['refresh_token'] as String? ?? '';

      if (accessToken.isEmpty || newRefreshToken.isEmpty) {
        return null;
      }

      return AuthTokens(
        accessToken: accessToken,
        refreshToken: newRefreshToken,
      );
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == 401 || status == 403) {
        return null;
      }
      rethrow;
    }
  }

  Options _withAuthorization(String apiKey) {
    return Options(
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
    );
  }

  Map<String, dynamic> _mapResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    throw DioException(
      requestOptions: RequestOptions(path: ''),
      type: DioExceptionType.badResponse,
      error: 'Unexpected response format',
    );
  }
}
