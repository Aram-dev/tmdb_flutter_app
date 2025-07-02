import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';

abstract class TrendingTvShowsUseCase {
  Future<MovieTvShowEntity> getTrendingTvShows(
    String apiKey,
    String language,
    String timeWindow,
  );
}
