import '../../models/movies_entity.dart';
import '../../usecases/top_rated/top_rated_movies_use_case.dart';

import '../../repositories/movie_repository.dart';

class TopRatedMoviesUseCaseImpl extends TopRatedMoviesUseCase {
  TopRatedMoviesUseCaseImpl({required this.repository});

  final MovieRepository repository;

  @override
  Future<MovieTvShowEntity> getTopRatedMovies(
    int page,
    String region,
    String language,
  ) async {
    return repository.getTopRatedMovies(page, region, language);
  }
}
