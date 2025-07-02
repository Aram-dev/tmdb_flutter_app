import '../../models/movies_entity.dart';
import '../../repositories/movie_repository.dart';
import '../../usecases/trending/trending_movies_use_case.dart';

class TrendingMoviesUseCaseImpl extends TrendingMoviesUseCase {
  TrendingMoviesUseCaseImpl({required this.repository});

  final MovieRepository repository;

  @override
  Future<MovieTvShowEntity> getTrendingMovies(
    String apiKey,
    String language,
    String timeWindow,
  ) async {
    return repository.getTrendingMovies(apiKey, language, timeWindow);
  }
}
