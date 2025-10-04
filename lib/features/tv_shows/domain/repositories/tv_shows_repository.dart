import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';

abstract class TvShowsRepository {

  Future<MovieTvShowEntity> getTrendingTvShows(
    String language,
    String timeWindow,
  );

  Future<MovieTvShowEntity> getAiringTodayTvShows(
    int page,
    String region,
    String language,
  );

  Future<MovieTvShowEntity> getOnTheAirTvShows(
    int page,
    String region,
    String language,
  );

  Future<MovieTvShowEntity> getPopularTvShows(
    int page,
    String region,
    String language,
  );

  Future<MovieTvShowEntity> getTopRatedTvShows(
    int page,
    String region,
    String language,
  );
}
