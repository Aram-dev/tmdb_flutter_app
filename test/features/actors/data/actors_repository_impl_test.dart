import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tmdb_flutter_app/features/actors/data/repositories/actors_repository_impl.dart';
import 'package:tmdb_flutter_app/features/actors/domain/models/actor_details.dart';

class MockDio extends Mock implements Dio {}

void main() {
  final getIt = GetIt.instance;
  late MockDio dio;
  late ActorsRepositoryImpl repository;
  late MemCacheStore store;
  late CacheOptions baseCacheOptions;

  setUpAll(() {
    registerFallbackValue<Options>(Options());
    registerFallbackValue<Map<String, dynamic>>(<String, dynamic>{});
  });

  setUp(() async {
    dio = MockDio();
    repository = ActorsRepositoryImpl(dio: dio);
    store = MemCacheStore();
    baseCacheOptions = CacheOptions(
      store: store,
      policy: CachePolicy.request,
      hitCacheOnErrorExcept: const [401, 403],
      maxStale: const Duration(days: 7),
      priority: CachePriority.high,
    );

    await getIt.reset();
    getIt.registerSingleton<CacheOptions>(baseCacheOptions);

    when(() => dio.options)
        .thenReturn(BaseOptions(baseUrl: 'https://api.themoviedb.org/3'));
  });

  tearDown(() async {
    await store.close();
    await getIt.reset();
  });

  group('ActorsRepositoryImpl caching', () {
    const language = 'en-US';
    const actorId = 42;
    final endpoint = '/person/$actorId';
    final params = <String, dynamic>{
      'language': language,
    };

    test('returns cached actor details without hitting network', () async {
      final cacheOptions = baseCacheOptions.copyWith(
        policy: CachePolicy.refresh,
        maxStale: Nullable(const Duration(hours: 6)),
        allowPostMethod: false,
      );
      final requestOptions = cacheOptions
          .toOptions()
          .compose(dio.options, endpoint, queryParameters: params);

      final cachedResponse = await CacheResponse.fromResponse(
        key: cacheOptions.keyBuilder(requestOptions),
        options: cacheOptions,
        response: Response<Map<String, dynamic>>(
          data: const {'id': actorId, 'name': 'Cached Name'},
          requestOptions: requestOptions,
          statusCode: 200,
        ),
      );

      await store.set(cachedResponse);

      final result = await repository.getActorDetails(actorId, language);

      expect(result, isA<ActorDetails>());
      expect(result.id, actorId);
      expect(result.name, 'Cached Name');
      verifyNever(
        () => dio.get<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      );
    });

    test('fetches network data when cache entry is stale', () async {
      final cacheOptions = baseCacheOptions.copyWith(
        policy: CachePolicy.refresh,
        maxStale: Nullable(const Duration(hours: 6)),
        allowPostMethod: false,
      );
      final requestOptions = cacheOptions
          .toOptions()
          .compose(dio.options, endpoint, queryParameters: params);

      final cachedResponse = await CacheResponse.fromResponse(
        key: cacheOptions.keyBuilder(requestOptions),
        options: cacheOptions,
        response: Response<Map<String, dynamic>>(
          data: const {'id': actorId, 'name': 'Old Name'},
          requestOptions: requestOptions,
          statusCode: 200,
        ),
      );

      final staleCache = CacheResponse(
        cacheControl: cachedResponse.cacheControl,
        content: cachedResponse.content,
        date: cachedResponse.date,
        eTag: cachedResponse.eTag,
        expires: cachedResponse.expires,
        headers: cachedResponse.headers,
        key: cachedResponse.key,
        lastModified: cachedResponse.lastModified,
        maxStale: DateTime.now().subtract(const Duration(minutes: 1)),
        priority: cachedResponse.priority,
        requestDate: cachedResponse.requestDate,
        responseDate: cachedResponse.responseDate,
        url: cachedResponse.url,
      );

      await store.set(staleCache);

      when(
        () => dio.get<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: const {'id': actorId, 'name': 'Fresh Name'},
          requestOptions: requestOptions,
          statusCode: 200,
        ),
      );

      final result = await repository.getActorDetails(actorId, language);

      expect(result.name, 'Fresh Name');
      verify(
        () => dio.get<dynamic>(
          endpoint,
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).called(1);
    });
  });
}
