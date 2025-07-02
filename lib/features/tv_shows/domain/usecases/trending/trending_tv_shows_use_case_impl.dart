import '../../../../movies/domain/models/movies_entity.dart';
import '../../repositories/tv_shows_repository.dart';
import '../../usecases/trending/trending_tv_shows_use_case.dart';

class TrendingTvShowsUseCaseImpl extends TrendingTvShowsUseCase {
  TrendingTvShowsUseCaseImpl({required this.repository});

  final TvShowsRepository repository;

  @override
  Future<MovieTvShowEntity> getTrendingTvShows(
    String apiKey,
    String language,
    String timeWindow,
  ) async {
    return repository.getTrendingTvShows(apiKey, language, timeWindow);
  }
}
