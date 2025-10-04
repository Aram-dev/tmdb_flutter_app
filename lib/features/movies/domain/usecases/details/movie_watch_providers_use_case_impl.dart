import '../../models/movie_watch_providers.dart';
import '../../repositories/movie_repository.dart';
import 'movie_watch_providers_use_case.dart';

class MovieWatchProvidersUseCaseImpl extends MovieWatchProvidersUseCase {
  MovieWatchProvidersUseCaseImpl({required this.repository});

  final MovieRepository repository;

  @override
  Future<MovieWatchProviders> getMovieWatchProviders(
    int movieId,
    String apiKey,
    String region,
  ) {
    return repository.getMovieWatchProviders(movieId, apiKey, region);
  }
}
