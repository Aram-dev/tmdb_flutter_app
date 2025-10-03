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
  }
  ) async {
    final response = await dio.get(
      endpoint,
      queryParameters: queryParams,
      options: _cacheOptions(maxStale: maxStale),
    );

    final data = response.data as Map<String, dynamic>;
    final dates = data.containsKey('dates')
        ? MoviesDates.fromJson(data['dates'])
        : null;
    final page = data.containsKey('page') ? data['page'] as int : null;
    final results =
        (data.containsKey('results') ? data['results'] as List : null)
            ?.map((json) => Movie.fromJson(json))
            .toList();
    final totalPages = data.containsKey('total_pages')
        ? data['total_pages'] as int
        : null;
    final totalResults = data.containsKey('total_results')
        ? data['total_results'] as int
        : null;

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
