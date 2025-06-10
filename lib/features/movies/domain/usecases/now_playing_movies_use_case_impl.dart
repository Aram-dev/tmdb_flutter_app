import 'package:tmdb_flutter_app/features/movies/domain/models/now_playing_entity.dart';
import 'package:tmdb_flutter_app/features/movies/domain/repositories/movies_now_playing.dart';
import 'package:tmdb_flutter_app/features/movies/domain/usecases/now_playing_movies_use_case.dart';

class NowPlayingMoviesUseCaseImpl extends NowPlayingMoviesUseCase {
  NowPlayingMoviesUseCaseImpl({required this.repository});

  final NowPlayingMoviesRepository repository;

  @override
  Future<NowPlayingEntity> getNowPlayingMovies(
    int page,
    String apiKey,
    String region,
    String language,
  ) async {
    return repository.getNowPlayingMovies(page, apiKey, region, language);
  }
}
