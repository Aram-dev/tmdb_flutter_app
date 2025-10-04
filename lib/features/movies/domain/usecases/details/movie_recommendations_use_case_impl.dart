import '../../models/movie_recommendations.dart';
import '../../repositories/movie_repository.dart';
import 'movie_recommendations_use_case.dart';

class MovieRecommendationsUseCaseImpl extends MovieRecommendationsUseCase {
  MovieRecommendationsUseCaseImpl({required this.repository});

  final MovieRepository repository;

  @override
  Future<MovieRecommendations> getMovieRecommendations(
    int movieId,
    String language,
  ) {
    return repository.getMovieRecommendations(movieId, language);
  }
}
