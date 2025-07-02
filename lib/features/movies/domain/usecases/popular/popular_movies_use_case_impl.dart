import '../../models/movies_entity.dart';
import '../../usecases/popular/popular_movies_use_case.dart';

import '../../repositories/movie_repository.dart';

class PopularMoviesUseCaseImpl extends PopularMoviesUseCase {
  PopularMoviesUseCaseImpl({required this.repository});

  final MovieRepository repository;

  @override
  Future<MovieTvShowEntity> getPopularMovies(
    int page,
    String apiKey,
    String region,
    String language,
  ) async {
    return repository.getUpcomingMovies(page, apiKey, region, language);
  }
}
