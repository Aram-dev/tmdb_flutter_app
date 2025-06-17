import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';

abstract class DiscoverTvShowsUseCase {
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
  );
}
