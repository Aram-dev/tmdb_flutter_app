import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tmdb_flutter_app/features/auth/data/interceptors/auth_interceptor.dart';
import 'package:tmdb_flutter_app/features/auth/domain/entities/auth_tokens.dart';
import 'package:tmdb_flutter_app/features/auth/domain/repositories/auth_repository.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _TestAdapter extends HttpClientAdapter {
  _TestAdapter(this.onFetch);

  final Future<ResponseBody> Function(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) onFetch;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return onFetch(options, requestStream, cancelFuture);
  }
}

void main() {
  late Dio dio;
  late _MockAuthRepository authRepository;

  setUpAll(() {
    registerFallbackValue(
      const AuthTokens(accessToken: '', refreshToken: ''),
    );
  });

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
    authRepository = _MockAuthRepository();
    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        authRepositoryProvider: () => authRepository,
      ),
    );
  });

  test('adds bearer token header when access token available', () async {
    when(() => authRepository.getAccessToken()).thenAnswer((_) async => 'token');

    late RequestOptions capturedOptions;
    dio.httpClientAdapter = _TestAdapter((options, __, ___) async {
      capturedOptions = options;
      return ResponseBody.fromString(
        '{}',
        200,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      );
    });

    final response = await dio.get('/movies');

    expect(response.statusCode, 200);
    expect(capturedOptions.headers['Authorization'], 'Bearer token');
    verify(() => authRepository.getAccessToken()).called(1);
  });

  test('refreshes tokens and retries the original request on 401', () async {
    when(() => authRepository.getAccessToken()).thenAnswer((_) async => 'expired');
    when(() => authRepository.refreshTokens()).thenAnswer(
      (_) async => const AuthTokens(accessToken: 'new-token', refreshToken: 'refresh'),
    );
    when(() => authRepository.saveTokens(any())).thenAnswer((_) async {});

    var callCount = 0;
    dio.httpClientAdapter = _TestAdapter((options, __, ___) async {
      callCount += 1;
      if (callCount == 1) {
        return ResponseBody.fromString(
          '{}',
          401,
          headers: {
            Headers.contentTypeHeader: ['application/json'],
          },
        );
      }

      expect(options.headers['Authorization'], 'Bearer new-token');
      return ResponseBody.fromString(
        '{}',
        200,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      );
    });

    final response = await dio.get('/protected');

    expect(response.statusCode, 200);
    expect(callCount, 2);
    verify(() => authRepository.refreshTokens()).called(1);
    verify(() => authRepository.saveTokens(const AuthTokens(accessToken: 'new-token', refreshToken: 'refresh'))).called(1);
    verifyNever(() => authRepository.clearTokens());
  });

  test('clears tokens and notifies logout when refresh fails', () async {
    when(() => authRepository.getAccessToken()).thenAnswer((_) async => 'expired');
    when(() => authRepository.refreshTokens()).thenThrow(Exception('fail'));
    when(() => authRepository.clearTokens()).thenAnswer((_) async {});
    when(() => authRepository.notifyLogout()).thenAnswer((_) {});

    dio.httpClientAdapter = _TestAdapter((options, __, ___) async {
      return ResponseBody.fromString(
        '{}',
        401,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      );
    });

    expect(
      () => dio.get('/protected'),
      throwsA(isA<DioException>()),
    );

    verify(() => authRepository.refreshTokens()).called(1);
    verify(() => authRepository.clearTokens()).called(1);
    verify(() => authRepository.notifyLogout()).called(1);
    verifyNever(() => authRepository.saveTokens(any()));
  });
}
