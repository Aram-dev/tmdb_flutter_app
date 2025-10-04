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
        queryParameters: {'api_key': apiKey},
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
      queryParameters: {'api_key': apiKey},
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
      queryParameters: {'api_key': apiKey},
      data: {
        'username': username,
        'password': password,
        'request_token': requestToken,
      },
    );
    return RequestTokenResponse.fromJson(_mapResponse(response.data));
  }

  Future<SessionResponse> createSession({
    required String apiKey,
    required String requestToken,
  }) async {
    final response = await _dio.post(
      '/authentication/session/new',
      queryParameters: {'api_key': apiKey},
      data: {'request_token': requestToken},
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
        'api_key': apiKey,
        'session_id': sessionId,
      },
    );
    return AccountResponse.fromJson(_mapResponse(response.data));
  }

  Future<AuthTokens> refreshTokens({required String refreshToken}) async {
    final response = await _dio.post(
      '/authentication/token/refresh',
      data: {'refresh_token': refreshToken},
    );
    final data = _mapResponse(response.data);
    final accessToken = (data['access_token'] as String?) ?? '';
    final newRefreshToken = (data['refresh_token'] as String?) ?? '';
    if (accessToken.isEmpty || newRefreshToken.isEmpty) {
      throw DioException(
        requestOptions: RequestOptions(path: '/authentication/token/refresh'),
        type: DioExceptionType.badResponse,
        error: 'Missing tokens in refresh response',
      );
    }
    return AuthTokens(accessToken: accessToken, refreshToken: newRefreshToken);
  }

  Map<String, dynamic> _mapResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data as Map);
    }
    throw DioException(
      requestOptions: RequestOptions(path: ''),
      type: DioExceptionType.badResponse,
      error: 'Unexpected response format',
    );
  }
}
