import '../../../../movies/domain/models/movies_entity.dart';
import '../../repositories/tv_shows_repository.dart';
import '../../usecases/popular/popular_tv_shows_use_case.dart';

class PopularTvShowsUseCaseImpl extends PopularTvShowsUseCase {
  PopularTvShowsUseCaseImpl({required this.repository});

  final TvShowsRepository repository;

  @override
  Future<MovieTvShowEntity> getPopularTvShows(
    int page,
    String apiKey,
    String region,
    String language,
  ) async {
    return repository.getPopularTvShows(page, apiKey, region, language);
  }
}
