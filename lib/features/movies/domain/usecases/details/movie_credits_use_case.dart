import '../../models/movie_credits.dart';

abstract class MovieCreditsUseCase {
  Future<MovieCredits> getMovieCredits(
    int movieId,
    String apiKey,
    String language,
  );
}
