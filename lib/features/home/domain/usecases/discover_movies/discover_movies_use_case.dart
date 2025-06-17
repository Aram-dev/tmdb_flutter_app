import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';

abstract class DiscoverMoviesUseCase {
  Future<MoviesEntity> getMovies(
    int page,
    int apiKey,
    String language,
    bool includeAdult,
    bool includeVideo,
    String certification,
    int primaryReleaseYear,
    String certificationGte,
    String certificationLte,
    String certificationCountry,
  );
}
