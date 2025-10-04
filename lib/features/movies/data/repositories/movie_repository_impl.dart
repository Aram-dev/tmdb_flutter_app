import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:get_it/get_it.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movie_credits.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movie_detail.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movie_recommendations.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movie_reviews.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movie_watch_providers.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';

import '../../domain/models/movie.dart';
import '../../domain/models/movies_dates_entity.dart';
import '../../domain/repositories/movie_repository.dart';

class MovieRepositoryImpl extends MovieRepository {
  MovieRepositoryImpl({required this.dio});

  final Dio dio;

  @override
  // Fetch trending movies. `timeWindow` can be "day" or "week".
  Future<MovieTvShowEntity> getTrendingMovies(
    String language,
    String timeWindow,
  ) async {
    final String endpoint = '/trending/movie/$timeWindow';
    final params = {
      'language': language,
    };
    return _fetchMoviesFromApi(
      endpoint,
      params,
      maxStale: const Duration(minutes: 30),
    );
  }

  @override
  Future<MovieTvShowEntity> getPopularMovies(
    int page,
    String region,
    String language,
  ) async {
    final String endpoint = '/movie/popular';
    final params = {
      'page': page,
      'region': region,
      'language': language,
    };
    return _fetchMoviesFromApi(
      endpoint,
      params,
      maxStale: const Duration(hours: 2),
    );
  }

  @override
  Future<MovieTvShowEntity> getNowPlayingMovies(
    int page,
    String region,
    String language,
  ) async {
    final String endpoint = '/movie/now_playing';
    final params = {
      'page': page,
      'region': region,
      'language': language,
    };
    return _fetchMoviesFromApi(
      endpoint,
      params,
      maxStale: const Duration(minutes: 5),
    );
  }

  @override
  Future<MovieTvShowEntity> getUpcomingMovies(
    int page,
    String region,
    String language,
  ) async {
    final String endpoint = '/movie/upcoming';
    final params = {
      'page': page,
      'region': region,
      'language': language,
    };
    return _fetchMoviesFromApi(
      endpoint,
      params,
      maxStale: const Duration(hours: 6),
    );
  }

  @override
  Future<MovieTvShowEntity> getTopRatedMovies(
    int page,
    String region,
    String language,
  ) async {
    final String endpoint = '/movie/top_rated';
    final params = {
      'page': page,
      'region': region,
      'language': language,
    };
    return _fetchMoviesFromApi(
      endpoint,
      params,
      maxStale: const Duration(hours: 12),
    );
  }

  @override
  Future<MovieDetail> getMovieDetails(
    int movieId,
    String language,
  ) async {
    final endpoint = '/movie/$movieId';
    final params = {
      'language': language,
    };
    final data = await _fetchJsonFromApi(
      endpoint,
      params,
      maxStale: const Duration(hours: 12),
    );
    return MovieDetail.fromJson(data);
  }

  @override
  Future<MovieCredits> getMovieCredits(
    int movieId,
    String language,
  ) async {
    final endpoint = '/movie/$movieId/credits';
    final params = {
      'language': language,
    };
    final data = await _fetchJsonFromApi(
      endpoint,
      params,
      maxStale: const Duration(hours: 12),
    );
    return MovieCredits.fromJson(data);
  }

  @override
  Future<MovieReviews> getMovieReviews(
    int movieId,
    String language,
  ) async {
    final endpoint = '/movie/$movieId/reviews';
    final params = {
      'language': language,
      'page': 1,
    };
    final data = await _fetchJsonFromApi(
      endpoint,
      params,
      maxStale: const Duration(hours: 1),
    );
    return MovieReviews.fromJson(data);
  }

  @override
  Future<MovieRecommendations> getMovieRecommendations(
    int movieId,
    String language,
  ) async {
    final endpoint = '/movie/$movieId/recommendations';
    final params = {
      'language': language,
      'page': 1,
    };
    final data = await _fetchJsonFromApi(
      endpoint,
      params,
      maxStale: const Duration(hours: 6),
    );
    return MovieRecommendations.fromJson(data);
  }

  @override
  Future<MovieWatchProviders> getMovieWatchProviders(
    int movieId,
    String region,
  ) async {
    final endpoint = '/movie/$movieId/watch/providers';
    final params = {
      'watch_region': region,
    };
    final data = await _fetchJsonFromApi(
      endpoint,
      params,
      maxStale: const Duration(hours: 24),
    );

    final results = data['results'];
    if (results is Map<String, dynamic>) {
      final regionData = results[region];
      if (regionData is Map<String, dynamic>) {
        return MovieWatchProviders.fromJson(regionData);
      }
      if (regionData is Map) {
        return MovieWatchProviders.fromJson(
          Map<String, dynamic>.from(regionData as Map),
        );
      }
    } else if (results is Map) {
      final regionData = results[region];
      if (regionData is Map<String, dynamic>) {
        return MovieWatchProviders.fromJson(regionData);
      }
      if (regionData is Map) {
        return MovieWatchProviders.fromJson(
          Map<String, dynamic>.from(regionData as Map),
        );
      }
    }

    return const MovieWatchProviders.empty();
  }

  Future<MovieTvShowEntity> _fetchMoviesFromApi(
    String endpoint,
    Map<String, Object?> queryParams, {
    required Duration maxStale,
  }) async {
    final data = await _fetchJsonFromApi(
      endpoint,
      queryParams,
      maxStale: maxStale,
    );
    return _mapToEntity(data);
  }

  Future<Map<String, dynamic>> _fetchJsonFromApi(
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
      return cachedData;
    }

    final response = await dio.get(
      endpoint,
      queryParameters: queryParams,
      options: cacheOptions.toOptions(),
    );

    return _normalizeResponseData(response.data);
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
