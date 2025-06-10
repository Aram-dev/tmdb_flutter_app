import 'package:tmdb_flutter_app/features/movies/domain/models/now_playing_entity.dart';

abstract class NowPlayingMoviesUseCase {
  Future<NowPlayingEntity> getNowPlayingMovies(
    int page,
    String apiKey,
    String region,
    String language,
  );
}
