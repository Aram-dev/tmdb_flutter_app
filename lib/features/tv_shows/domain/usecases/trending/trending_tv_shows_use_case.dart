import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';

abstract class TrendingTvShowsUseCase {
  Future<MovieTvShowEntity> getTrendingTvShows(
    String language,
    String timeWindow,
  );
}
