import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';

abstract class TopRatedTvShowsUseCase {
  Future<MovieTvShowEntity> getTopRatedTvShows(
    int page,
    String region,
    String language,
  );
}
