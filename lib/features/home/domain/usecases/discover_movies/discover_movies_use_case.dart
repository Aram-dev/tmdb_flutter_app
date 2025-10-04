import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';

abstract class DiscoverContentUseCase {
  Future<MovieTvShowEntity> getDiscoverContent({
    required int page,
    required String language,
    required String category,
    String region,
    bool? includeAdult,
    bool? includeVideo,
    String? certification,
    int? primaryReleaseYear,
    String? certificationGte,
    String? certificationLte,
    String? certificationCountry,
  });
}
