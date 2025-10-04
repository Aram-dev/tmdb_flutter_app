import '../../models/movies_entity.dart';
import '../../repositories/movie_repository.dart';
import '../../usecases/popular/popular_movies_use_case.dart';

class PopularMoviesUseCaseImpl extends PopularMoviesUseCase {
  PopularMoviesUseCaseImpl({required this.repository});

  final MovieRepository repository;

  @override
  Future<MovieTvShowEntity> getPopularMovies(
    int page,
    String region,
    String language,
  ) async {
    return repository.getPopularMovies(page, region, language);
  }
}
