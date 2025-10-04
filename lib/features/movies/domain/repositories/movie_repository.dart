import 'package:tmdb_flutter_app/features/movies/domain/models/movie_credits.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movie_detail.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movie_recommendations.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movie_reviews.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movie_watch_providers.dart';
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

  Future<MovieDetail> getMovieDetails(
    int movieId,
    String apiKey,
    String language,
  );

  Future<MovieCredits> getMovieCredits(
    int movieId,
    String apiKey,
    String language,
  );

  Future<MovieReviews> getMovieReviews(
    int movieId,
    String apiKey,
    String language,
  );

  Future<MovieRecommendations> getMovieRecommendations(
    int movieId,
    String apiKey,
    String language,
  );

  Future<MovieWatchProviders> getMovieWatchProviders(
    int movieId,
    String apiKey,
    String region,
  );
}
