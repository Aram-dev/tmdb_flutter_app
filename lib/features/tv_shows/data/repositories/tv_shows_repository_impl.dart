import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:get_it/get_it.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';

import '../../../movies/domain/models/movie.dart';
import '../../../movies/domain/models/movies_dates_entity.dart';
import '../../domain/repositories/tv_shows_repository.dart';

class TvShowsRepositoryImpl extends TvShowsRepository {
  TvShowsRepositoryImpl({required this.dio});

  final Dio dio;

  @override
  // Fetch trending TvShowss. `timeWindow` can be "day" or "week".
  Future<MovieTvShowEntity> getTrendingTvShows(
      String apiKey,
      String language,
      String timeWindow,
      ) async {
    final String endpoint = '/trending/tv/$timeWindow';
    final params = {
      'api_key': apiKey,
      'language': language,
    };
    return _fetchTvShowsFromApi(
      endpoint,
      params,
      maxStale: const Duration(minutes: 30),
    );
  }

  @override
  Future<MovieTvShowEntity> getAiringTodayTvShows(
      int page,
      String apiKey,
      String timezone,
      String language,
      ) async {
    final String endpoint = '/tv/airing_today';
    final params = {
      'page': page,
      'api_key': apiKey,
      'timezone': timezone,
      'language': language,
    };
    return _fetchTvShowsFromApi(
      endpoint,
      params,
      maxStale: const Duration(minutes: 5),
    );
  }

  @override
  Future<MovieTvShowEntity> getOnTheAirTvShows(
      int page,
      String apiKey,
      String region,
      String language,
      ) async {
    final String endpoint = '/tv/on_the_air';
    final params = {
      'page': page,
      'api_key': apiKey,
      'region': region,
      'language': language,
    };
    return _fetchTvShowsFromApi(
      endpoint,
      params,
      maxStale: const Duration(minutes: 15),
    );
  }

  @override
  Future<MovieTvShowEntity> getPopularTvShows(
    int page,
    String apiKey,
    String region,
    String language,
  ) async {
    final String endpoint = '/tv/popular';
    final params = {
      'page': page,
      'api_key': apiKey,
      'region': region,
      'language': language,
    };
    return _fetchTvShowsFromApi(
      endpoint,
      params,
      maxStale: const Duration(hours: 2),
    );
  }

  @override
  Future<MovieTvShowEntity> getTopRatedTvShows(
      int page,
      String apiKey,
      String region,
      String language,
      ) async {
    final String endpoint = '/tv/top_rated';
    final params = {
      'page': page,
      'api_key': apiKey,
      'region': region,
      'language': language,
    };
    return _fetchTvShowsFromApi(
      endpoint,
      params,
      maxStale: const Duration(hours: 12),
    );
  }

  Future<MovieTvShowEntity> _fetchTvShowsFromApi(
    String endpoint,
    Map<String, Object?> queryParams, {
    required Duration maxStale,
  }) async {
    final cacheOptions = _cacheOptions(maxStale: maxStale);
    final cachedData = await _tryGetCachedData(
      cacheOptions: cacheOptions,
      endpoint: endpoint,
      queryParams: queryParams,
    );

    if (cachedData != null) {
      return _mapToEntity(cachedData);
    }

    final response = await dio.get(
      endpoint,
      queryParameters: queryParams,
      options: cacheOptions.toOptions(),
    );

    final data = _normalizeResponseData(response.data);
    return _mapToEntity(data);
  }

  CacheOptions _cacheOptions({required Duration maxStale}) {
    return GetIt.I<CacheOptions>().copyWith(
          policy: CachePolicy.request,
          maxStale: Nullable(maxStale),
        );
  }

  Future<Map<String, dynamic>?> _tryGetCachedData({
    required CacheOptions cacheOptions,
    required String endpoint,
    required Map<String, Object?> queryParams,
  }) async {
    if (cacheOptions.policy == CachePolicy.refresh) {
      return null;
    }

    final store = cacheOptions.store;
    if (store == null) {
      return null;
    }

    final requestOptions = cacheOptions
        .toOptions()
        .compose(dio.options, endpoint, queryParameters: queryParams);
    final cacheKey = cacheOptions.keyBuilder(requestOptions);
    final cachedResponse = await store.get(cacheKey);

    if (cachedResponse == null) {
      return null;
    }

    if (cachedResponse.isStaled()) {
      await store.delete(cacheKey, staleOnly: true);
      return null;
    }

    final cachedData = cachedResponse.toResponse(requestOptions).data;
    return _normalizeResponseData(cachedData);
  }

  Map<String, dynamic> _normalizeResponseData(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data as Map);
    }
    return <String, dynamic>{};
  }

  MovieTvShowEntity _mapToEntity(Map<String, dynamic> data) {
    final datesRaw = data['dates'];
    MoviesDates? dates;
    if (datesRaw is Map<String, dynamic>) {
      dates = MoviesDates.fromJson(datesRaw);
    } else if (datesRaw is Map) {
      dates = MoviesDates.fromJson(Map<String, dynamic>.from(datesRaw as Map));
    }

    final resultsRaw = data['results'];
    final results = resultsRaw is List
        ? resultsRaw
            .whereType<Map<String, dynamic>>()
            .map(Movie.fromJson)
            .toList()
        : null;

    return MovieTvShowEntity(
      dates: dates,
      page: (data['page'] as num?)?.toInt(),
      results: results,
      totalPages: (data['total_pages'] as num?)?.toInt(),
      totalResults: (data['total_results'] as num?)?.toInt(),
    );
  }
}
