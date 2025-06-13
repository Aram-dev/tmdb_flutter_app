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
      'language': language,
    };
    return _fetchMoviesFromApi(endpoint, params);
  }

  Future<MoviesEntity> _fetchMoviesFromApi(
    String endpoint,
    Map<String, Object> queryParams) async {
    final response = await dio.get(endpoint, queryParameters: queryParams);

    final data = response.data as Map<String, dynamic>;
    final dates = MoviesDates.fromJson(data['dates']);
    final page = data['page'] as int;
    final results = (data['results'] as List)
        .map((json) => Movie.fromJson(json))
        .toList();
    final totalPages = data['total_pages'] as int;
    final totalResults = data['total_results'] as int;

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
