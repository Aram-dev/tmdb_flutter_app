import 'package:dio/dio.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/now_playing_dates.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/now_playing_entity.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/now_playing_results.dart';
import 'package:tmdb_flutter_app/features/movies/domain/repositories/movies_now_playing.dart';

class NowPlayingMoviesRepositoryImpl extends NowPlayingMoviesRepository {
  NowPlayingMoviesRepositoryImpl({required this.dio});

  final Dio dio;

  @override
  Future<NowPlayingEntity> getNowPlayingMovies(int page,
      String apiKey,
      String region,
      String language,) async {
    final params = {
      'page': page,
      'api_key': apiKey,
      'region': region,
      'language': language,
    };

    return _fetchNowPlayingMoviesFromApi(params);
  }

  Future<NowPlayingEntity> _fetchNowPlayingMoviesFromApi(
      Map<String, Object> params,) async {
    final response = await dio.get(
      'https://api.themoviedb.org/3/movie/now_playing',
      queryParameters: params,
    );

    final data = response.data as Map<String, dynamic>;
    final dates = NowPlayingDates.fromJson(data['dates']);
    final page = data['page'] as int;
    final results = (data['results'] as List)
        .map((json) => NowPlayingResults.fromJson(json))
        .toList();
    final totalPages = data['total_pages'] as int;
    final totalResults = data['total_results'] as int;

    final entity = NowPlayingEntity(dates: dates,
        page: page,
        results: results,
        totalPages: totalPages,
        totalResults: totalResults
    );

    return entity;
  }
}
