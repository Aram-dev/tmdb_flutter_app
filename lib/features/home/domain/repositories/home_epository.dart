import '../../../movies/domain/models/movies_entity.dart';

abstract class HomeRepository {
  Future<MovieTvShowEntity> getDiscoverContent(
    int page,
    String apiKey,
    String language,
    String category,
    String? region,
    bool? includeAdult,
    bool? includeVideo,
    String? certification,
    int? primaryReleaseYear,
    String? certificationGte,
    String? certificationLte,
    String? certificationCountry,
  );
}
