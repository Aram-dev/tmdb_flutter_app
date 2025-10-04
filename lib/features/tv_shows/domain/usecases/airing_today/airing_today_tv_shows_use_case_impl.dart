import '../../../../movies/domain/models/movies_entity.dart';
import '../../repositories/tv_shows_repository.dart';
import 'airing_today_tv_shows_use_case.dart';

class AiringTodayTvShowsUseCaseImpl extends AiringTodayTvShowsUseCase {
  AiringTodayTvShowsUseCaseImpl({required this.repository});

  final TvShowsRepository repository;

  @override
  Future<MovieTvShowEntity> getAiringTodayTvShows(
    int page,
    String timezone,
    String language,
  ) async {
    return repository.getAiringTodayTvShows(page, timezone, language);
  }
}
