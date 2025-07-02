import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';

abstract class MovieRepository {

  Future<MovieTvShowEntity> getTrendingMovies(
      String apiKey,
      String language,
      String timeWindow,
      );

  Future<MovieTvShowEntity> getPopularMovies(
    int page,
    String apiKey,
    String region,
    String language,
  );

  Future<MovieTvShowEntity> getNowPlayingMovies(
    int page,
    String apiKey,
    String region,
    String language,
  );

  Future<MovieTvShowEntity> getUpcomingMovies(
      int page,
      String apiKey,
      String region,
      String language,
      );

  Future<MovieTvShowEntity> getTopRatedMovies(
      int page,
      String apiKey,
      String region,
      String language,
      );
}
