import 'package:dio/dio.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';

import '../../domain/models/movies_dates_entity.dart';
import '../../domain/models/movie.dart';
import '../../domain/repositories/movie_repository.dart';

class MovieRepositoryImpl extends MovieRepository {
  MovieRepositoryImpl({required this.dio});

  final Dio dio;

  @override
  // Fetch trending movies. `timeWindow` can be "today" or "week".
  Future<MoviesEntity> getTrendingMovies(
      String apiKey,
      String language,
      String timeWindow,
      ) async {
    final String endpoint = '/trending/movie/$timeWindow';
    final params = {
      'api_key': apiKey,
      'language': language,
    };
    return _fetchMoviesFromApi(endpoint, params);
  }

  @override
  Future<MoviesEntity> getPopularMovies(
    int page,
    String apiKey,
    String region,
    String language,
  ) async {
    final String endpoint = '/movie/popular';
    final params = {
      'page': page,
      'api_key': apiKey,
      'region': region,
      'language': language,
    };
    return _fetchMoviesFromApi(endpoint, params);
  }

  @override
  Future<MoviesEntity> getNowPlayingMovies(
    int page,
    String apiKey,
    String region,
    String language,
  ) async {
    final String endpoint = '/movie/now_playing';
    final params = {
      'page': page,
      'api_key': apiKey,
      'region': region,
      'language': language,
    };
    return _fetchMoviesFromApi(endpoint, params);
  }

  @override
  Future<MoviesEntity> getUpcomingMovies(
      int page,
      String apiKey,
      String region,
      String language,
      ) async {
    final String endpoint = '/movie/upcoming';
    final params = {
      'page': page,
      'api_key': apiKey,
      'region': region,
      'language': language,
    };
    return _fetchMoviesFromApi(endpoint, params);
  }

  @override
  Future<MoviesEntity> getTopRatedMovies(
      int page,
      String apiKey,
      String region,
      String language,
      ) async {
    final String endpoint = '/movie/top_rated';
    final params = {
      'page': page,
      'api_key': apiKey,
      'region': region,
      'language': language,
    };
    return _fetchMoviesFromApi(endpoint, params);
  }

  Future<MoviesEntity> _fetchMoviesFromApi(
    String endpoint,
    Map<String, Object> queryParams) async {
    final response = await dio.get(endpoint, queryParameters: queryParams);

    final data = response.data as Map<String, dynamic>;
    final dates = data.containsKey('dates') ? MoviesDates.fromJson(data['dates']) : null;
    final page =  data.containsKey('page') ? data['page'] as int : null ;
    final results = (data.containsKey('results') ? data['results'] as List : null)
        ?.map((json) => Movie.fromJson(json))
        .toList();
    final totalPages = data.containsKey('total_pages') ? data['total_pages'] as int : null;
    final totalResults = data.containsKey('total_results') ? data['total_results'] as int : null;

    final entity = MoviesEntity(
      dates: dates,
      page: page,
      results: results,
      totalPages: totalPages,
      totalResults: totalResults,
    );

    return entity;
  }
}
