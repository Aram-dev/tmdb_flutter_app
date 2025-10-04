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
      return Map<String, dynamic>.from(data as Map);
    }
    throw DioException(
      requestOptions: RequestOptions(path: ''),
      type: DioExceptionType.badResponse,
      error: 'Unexpected response format',
    );
  }
}
