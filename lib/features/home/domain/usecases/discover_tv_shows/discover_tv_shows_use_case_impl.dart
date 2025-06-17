import '../../../../movies/domain/models/movies_entity.dart';
import '../../repositories/home_epository.dart';
import 'discover_tv_shows_use_case.dart';

class DiscoverTvShowsUseCaseImpl extends DiscoverTvShowsUseCase {
  DiscoverTvShowsUseCaseImpl({required this.repository});

  final HomeRepository repository;

  @override
  Future<MoviesEntity> getTvShows(
    int page,
    String apiKey,
    String region,
    String language,
    bool includeAdult,
    DateTime airDateGte,
    DateTime airDateLte,
    int firstAirDateYear,
    DateTime firstAirDateGte,
    DateTime firstAirDateLte,
  ) async {
    return repository.getTvShows(
      page,
      apiKey,
      region,
      language,
      includeAdult,
      airDateGte,
      airDateLte,
      firstAirDateYear,
      firstAirDateGte,
      firstAirDateLte,
    );
  }
}
