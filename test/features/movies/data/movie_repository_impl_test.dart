import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tmdb_flutter_app/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';

class MockDio extends Mock implements Dio {}

void main() {
  final getIt = GetIt.instance;
  late MockDio dio;
  late MovieRepositoryImpl repository;
  late MemCacheStore store;
  late CacheOptions baseCacheOptions;

  setUpAll(() {
    registerFallbackValue(Options());
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() async {
    dio = MockDio();
    repository = MovieRepositoryImpl(dio: dio);
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

  group('MovieRepositoryImpl caching', () {
    test('returns cached trending movies without network call', () async {
      const language = 'en-US';
      const timeWindow = 'day';
      final endpoint = '/trending/movie/$timeWindow';
      final params = <String, dynamic>{
        'language': language,
      };

      final cacheOptions = baseCacheOptions.copyWith(
        policy: CachePolicy.request,
        maxStale: Nullable(const Duration(minutes: 30)),
      );
      final requestOptions = cacheOptions
          .toOptions()
          .compose(dio.options, endpoint, queryParameters: params);

      final cachedResponse = await CacheResponse.fromResponse(
        key: cacheOptions.keyBuilder(requestOptions),
        options: cacheOptions,
        response: Response<Map<String, dynamic>>(
          data: <String, dynamic>{
            'dates': {'maximum': '2024-01-01', 'minimum': '2023-12-01'},
            'page': 1,
            'results': [
              {
                'adult': false,
                'backdrop_path': '/path',
                'genre_ids': [1, 2],
                'id': 100,
                'original_language': 'en',
                'original_title': 'Original',
                'overview': 'Overview',
                'popularity': 10.0,
                'poster_path': '/poster',
                'release_date': '2023-12-01',
                'title': 'Cached Movie',
                'video': false,
                'vote_average': 7.1,
                'vote_count': 50,
              }
            ],
            'total_pages': 1,
            'total_results': 1,
          },
          requestOptions: requestOptions,
          statusCode: 200,
        ),
      );

      await store.set(cachedResponse);

      final result =
          await repository.getTrendingMovies(language, timeWindow);

      expect(result, isA<MovieTvShowEntity>());
      expect(result.results, isNotNull);
      expect(result.results, hasLength(1));
      expect(result.results?.first.title, 'Cached Movie');

      verifyNever(
        () => dio.get<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      );
    });
  });
}
