import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';

abstract class MovieRepository {

  Future<MoviesEntity> getTrendingMovies(
      String apiKey,
      String language,
      String timeWindow,
      );

  Future<MoviesEntity> getPopularMovies(
    int page,
    String apiKey,
    String region,
    String language,
  );

  Future<MoviesEntity> getNowPlayingMovies(
    int page,
    String apiKey,
    String region,
    String language,
  );

  Future<MoviesEntity> getUpcomingMovies(
      int page,
      String apiKey,
      String region,
      String language,
      );

  Future<MoviesEntity> getTopRatedMovies(
      int page,
      String apiKey,
      String region,
      String language,
      );
}
