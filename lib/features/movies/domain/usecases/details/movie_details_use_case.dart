import '../../models/movie_detail.dart';

abstract class MovieDetailsUseCase {
  Future<MovieDetail> getMovieDetails(
    int movieId,
    String apiKey,
    String language,
  );
}
