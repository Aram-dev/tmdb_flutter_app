import '../../../../movies/domain/models/movies_entity.dart';
import '../../repositories/home_epository.dart';
import 'discover_movies_use_case.dart';

class DiscoverMoviesUseCaseImpl extends DiscoverMoviesUseCase {
  DiscoverMoviesUseCaseImpl({required this.repository});

  final HomeRepository repository;

  @override
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
  ) async {
    return repository.getMovies(
      page,
      apiKey,
      language,
      includeAdult,
      includeVideo,
      certification,
      primaryReleaseYear,
      certificationGte,
      certificationLte,
      certificationCountry,
    );
  }
}
