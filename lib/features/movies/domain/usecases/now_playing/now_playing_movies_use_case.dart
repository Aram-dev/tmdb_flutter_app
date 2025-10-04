import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';

abstract class NowPlayingMoviesUseCase {
  Future<MovieTvShowEntity> getNowPlayingMovies(
    int page,
    String region,
    String language,
  );
}
