import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';

abstract class AiringTodayTvShowsUseCase {
  Future<MovieTvShowEntity> getAiringTodayTvShows(
    int page,
    String timezone,
    String language,
  );
}
