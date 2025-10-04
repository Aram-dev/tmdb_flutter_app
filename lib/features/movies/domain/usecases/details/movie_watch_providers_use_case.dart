import '../../models/movie_watch_providers.dart';

abstract class MovieWatchProvidersUseCase {
  Future<MovieWatchProviders> getMovieWatchProviders(
    int movieId,
    String apiKey,
    String region,
  );
}
