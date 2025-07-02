import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';

abstract class PopularTvShowsUseCase {
  Future<MovieTvShowEntity> getPopularTvShows(
    int page,
    String apiKey,
    String region,
    String language,
  );
}
