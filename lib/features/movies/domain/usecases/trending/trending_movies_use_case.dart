import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';

abstract class TrendingMoviesUseCase {
  Future<MoviesEntity> getTrendingMovies(
    String apiKey,
    String language,
    String timeWindow,
  );
}
