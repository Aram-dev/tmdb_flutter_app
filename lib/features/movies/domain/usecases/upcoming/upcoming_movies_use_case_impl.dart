import '../../models/movies_entity.dart';
import '../../usecases/upcoming/upcoming_movies_use_case.dart';

import '../../repositories/movie_repository.dart';

class UpcomingMoviesUseCaseImpl extends UpcomingMoviesUseCase {
  UpcomingMoviesUseCaseImpl({required this.repository});

  final MovieRepository repository;

  @override
  Future<MovieTvShowEntity> getUpcomingMovies(
    int page,
    String apiKey,
    String region,
    String language,
  ) async {
    return repository.getUpcomingMovies(page, apiKey, region, language);
  }
}
