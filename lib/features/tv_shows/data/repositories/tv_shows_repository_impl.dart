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
    final response = await dio.get(
      endpoint,
      queryParameters: queryParams,
      options: _cacheOptions(maxStale: maxStale),
    );

    final data = response.data as Map<String, dynamic>;
    final dates = data.containsKey('dates') ? MoviesDates.fromJson(data['dates']) : null;
    final page =  data.containsKey('page') ? data['page'] as int : null ;
    final results = (data.containsKey('results') ? data['results'] as List : null)
        ?.map((json) => Movie.fromJson(json))
        .toList();
    final totalPages = data.containsKey('total_pages') ? data['total_pages'] as int : null;
    final totalResults = data.containsKey('total_results') ? data['total_results'] as int : null;

    final entity = MovieTvShowEntity(
      dates: dates,
      page: page,
      results: results,
      totalPages: totalPages,
      totalResults: totalResults,
    );

    return entity;
  }

  Options _cacheOptions({required Duration maxStale}) {
    return GetIt.I<CacheOptions>()
        .copyWith(
          policy: CachePolicy.refresh,
          maxStale: Nullable(maxStale),
        )
        .toOptions();
  }
}
