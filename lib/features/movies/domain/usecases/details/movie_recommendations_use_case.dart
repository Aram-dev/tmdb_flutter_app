import '../../models/movie_recommendations.dart';

abstract class MovieRecommendationsUseCase {
  Future<MovieRecommendations> getMovieRecommendations(
    int movieId,
    String apiKey,
    String language,
  );
}
