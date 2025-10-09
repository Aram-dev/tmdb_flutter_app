import 'dart:async';

import 'package:dio/dio.dart';

import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required Dio dio,
    required AuthRepository Function() authRepositoryProvider,
  })  : _dio = dio,
        _authRepositoryProvider = authRepositoryProvider;

  static const _retryExtraKey = 'auth_retry';

  final Dio _dio;
  final AuthRepository Function() _authRepositoryProvider;
  Completer<AuthTokens?>? _refreshCompleter;

  AuthRepository get _authRepository => _authRepositoryProvider();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // Inject TMDB API key from env define if provided
      const envApiKey = String.fromEnvironment('TMDB_API_KEY');
      if (envApiKey.isNotEmpty) {
        options.queryParameters['api_key'] = envApiKey;
      }

      // Inject bearer token if available
      final token = await _authRepository.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // Ignore token loading failures and continue without auth header.
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;
    final statusCode = response?.statusCode;
    final alreadyRetried = err.requestOptions.extra[_retryExtraKey] == true;

    if (statusCode == 401 && !alreadyRetried) {
      try {
        final tokens = await _refreshTokens();
        if (tokens == null || !tokens.hasAccessToken) {
          await _handleRefreshFailure();
          handler.next(err);
          return;
        }

        await _authRepository.saveTokens(tokens);
        final updatedHeaders = Map<String, dynamic>.from(err.requestOptions.headers)
          ..['Authorization'] = 'Bearer ${tokens.accessToken}';
        final updatedExtra = Map<String, dynamic>.from(err.requestOptions.extra)
          ..[_retryExtraKey] = true;

        final requestOptions = err.requestOptions.copyWith(
          headers: updatedHeaders,
          extra: updatedExtra,
        );

        try {
          final response = await _dio.fetch<dynamic>(requestOptions);
          handler.resolve(response);
          return;
        } on DioException catch (dioError) {
          handler.next(dioError);
          return;
        }
      } catch (_) {
        await _handleRefreshFailure();
        handler.next(err);
        return;
      }
    }

    handler.next(err);
  }

  Future<AuthTokens?> _refreshTokens() {
    final existingCompleter = _refreshCompleter;
    if (existingCompleter != null) {
      return existingCompleter.future;
    }

    final completer = Completer<AuthTokens?>();
    _refreshCompleter = completer;

    () async {
      try {
        final tokens = await _authRepository.refreshTokens();
        completer.complete(tokens);
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      } finally {
        _refreshCompleter = null;
      }
    }();

    return completer.future;
  }

  Future<void> _handleRefreshFailure() async {
    await _authRepository.clearTokens();
    _authRepository.notifyLogout();
  }
}
