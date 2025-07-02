import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';

abstract class UpcomingMoviesUseCase {
  Future<MovieTvShowEntity> getUpcomingMovies(
    int page,
    String apiKey,
    String region,
    String language,
  );
}
