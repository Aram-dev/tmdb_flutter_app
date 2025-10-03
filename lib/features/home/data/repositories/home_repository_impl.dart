import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';

import '../../../movies/domain/models/movie.dart';
import '../../../movies/domain/models/movies_dates_entity.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  HomeRepositoryImpl({required this.dio});

  final Dio dio;

  @override
  Future<MovieTvShowEntity> getDiscoverContent(
    int page,
    String apiKey,
    String language,
    String category,
    String? region,
    bool? includeAdult,
    bool? includeVideo,
    String? certification,
    int? primaryReleaseYear,
    String? certificationGte,
    String? certificationLte,
    String? certificationCountry,
  ) {
    GetIt.I.get<Talker>().log('getDiscoverContent - $category');
    final String endpoint = '/discover/$category';
    final params = {
      'page': page,
      'api_key': apiKey,
      'region': region,
      'language': language,
      'include_adult': false,
      'include_video': false,
    };

    return _fetchMoviesFromApi(
      endpoint,
      params,
      maxStale: const Duration(minutes: 45),
    );
  }

  Future<MovieTvShowEntity> _fetchMoviesFromApi(
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
