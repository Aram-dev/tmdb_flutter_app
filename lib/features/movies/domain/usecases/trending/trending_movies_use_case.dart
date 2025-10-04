import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';

abstract class TrendingMoviesUseCase {
  Future<MovieTvShowEntity> getTrendingMovies(
    String language,
    String timeWindow,
  );
}
