import '../../models/movie_reviews.dart';

abstract class MovieReviewsUseCase {
  Future<MovieReviews> getMovieReviews(
    int movieId,
    String language,
  );
}
