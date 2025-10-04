import '../../models/movie_credits.dart';
import '../../repositories/movie_repository.dart';
import 'movie_credits_use_case.dart';

class MovieCreditsUseCaseImpl extends MovieCreditsUseCase {
  MovieCreditsUseCaseImpl({required this.repository});

  final MovieRepository repository;

  @override
  Future<MovieCredits> getMovieCredits(
    int movieId,
    String apiKey,
    String language,
  ) {
    return repository.getMovieCredits(movieId, apiKey, language);
  }
}
