import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';
import 'package:tmdb_flutter_app/features/movies/domain/usecases/now_playing/now_playing_movies_use_case.dart';

import '../../repositories/movie_repository.dart';

class NowPlayingMoviesUseCaseImpl extends NowPlayingMoviesUseCase {
  NowPlayingMoviesUseCaseImpl({required this.repository});

  final MovieRepository repository;

  @override
  Future<MoviesEntity> getNowPlayingMovies(
    int page,
    String apiKey,
    String region,
    String language,
  ) async {
    return repository.getNowPlayingMovies(page, apiKey, region, language);
  }
}
