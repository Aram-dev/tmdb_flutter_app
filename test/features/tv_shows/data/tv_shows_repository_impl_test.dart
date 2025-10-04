import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';
import 'package:tmdb_flutter_app/features/tv_shows/data/repositories/tv_shows_repository_impl.dart';

class MockDio extends Mock implements Dio {}

void main() {
  final getIt = GetIt.instance;
  late MockDio dio;
  late TvShowsRepositoryImpl repository;
  late MemCacheStore store;
  late CacheOptions baseCacheOptions;

  setUpAll(() {
    registerFallbackValue<Options>(Options());
    registerFallbackValue<Map<String, dynamic>>(<String, dynamic>{});
  });

  setUp(() async {
    dio = MockDio();
    repository = TvShowsRepositoryImpl(dio: dio);
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

  group('TvShowsRepositoryImpl caching', () {
    test('returns cached trending tv shows without network call', () async {
      const language = 'en-US';
      const timeWindow = 'day';
      final endpoint = '/trending/tv/$timeWindow';
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
            'dates': {'maximum': '2024-03-01', 'minimum': '2024-02-01'},
            'page': 1,
            'results': [
              {
                'adult': false,
                'backdrop_path': '/path',
                'genre_ids': [1, 2],
                'id': 300,
                'original_language': 'en',
                'original_title': 'Trending Show',
                'overview': 'Overview',
                'popularity': 20.0,
                'poster_path': '/poster',
                'release_date': '2024-02-15',
                'title': 'Cached Show',
                'video': false,
                'vote_average': 9.0,
                'vote_count': 100,
              }
            ],
            'total_pages': 3,
            'total_results': 60,
          },
          requestOptions: requestOptions,
          statusCode: 200,
        ),
      );

      await store.set(cachedResponse);

      final result =
          await repository.getTrendingTvShows(language, timeWindow);

      expect(result, isA<MovieTvShowEntity>());
      expect(result.results, isNotNull);
      expect(result.results, hasLength(1));
      expect(result.results?.first.title, 'Cached Show');

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
