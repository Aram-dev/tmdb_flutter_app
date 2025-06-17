import '../../../movies/domain/models/movies_entity.dart';

abstract class HomeRepository {
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
