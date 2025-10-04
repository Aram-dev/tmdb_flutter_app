import '../../models/movie_reviews.dart';
import '../../repositories/movie_repository.dart';
import 'movie_reviews_use_case.dart';

class MovieReviewsUseCaseImpl extends MovieReviewsUseCase {
  MovieReviewsUseCaseImpl({required this.repository});

  final MovieRepository repository;

  @override
  Future<MovieReviews> getMovieReviews(
    int movieId,
    String apiKey,
    String language,
  ) {
    return repository.getMovieReviews(movieId, apiKey, language);
  }
}
