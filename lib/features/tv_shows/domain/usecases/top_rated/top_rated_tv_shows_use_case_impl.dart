import '../../../../movies/domain/models/movies_entity.dart';
import '../../repositories/tv_shows_repository.dart';
import '../../usecases/top_rated/top_rated_tv_shows_use_case.dart';

class TopRatedTvShowsUseCaseImpl extends TopRatedTvShowsUseCase {
  TopRatedTvShowsUseCaseImpl({required this.repository});

  final TvShowsRepository repository;

  @override
  Future<MovieTvShowEntity> getTopRatedTvShows(
    int page,
    String apiKey,
    String region,
    String language,
  ) async {
    return repository.getTopRatedTvShows(page, apiKey, region, language);
  }
}
