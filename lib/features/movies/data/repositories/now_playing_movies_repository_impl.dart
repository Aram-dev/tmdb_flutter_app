import 'package:dio/dio.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/now_playing_entity.dart';
import 'package:tmdb_flutter_app/features/movies/domain/repositories/movies_now_playing.dart';

class NowPlayingMoviesRepositoryImpl extends NowPlayingMoviesRepository {
  NowPlayingMoviesRepositoryImpl({required this.dio});

  final Dio dio;

  @override
  Future<NowPlayingEntity> getNowPlayingMovies(
    int page,
    String apiKey,
    String region,
    String language,
  ) async {
    final params = {
      'page': page,
      'api_key': apiKey,
      'region': region,
      'language': language,
    };

    return _fetchNowPlayingMoviesFromApi(params);
  }

  Future<NowPlayingEntity> _fetchNowPlayingMoviesFromApi(
    Map<String, Object> params,
  ) async {
    final response = await dio.get(
      'https://api.themoviedb.org/3/movie/now_playing',
      queryParameters: params,
    );

    final nowPlayingEntity = response as NowPlayingEntity;

    return nowPlayingEntity;
  }
}
