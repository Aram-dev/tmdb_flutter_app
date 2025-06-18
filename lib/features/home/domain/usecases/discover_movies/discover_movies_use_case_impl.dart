import '../../../../movies/domain/models/movies_entity.dart';
import '../../repositories/home_epository.dart';
import 'discover_movies_use_case.dart';

class DiscoverContentUseCaseImpl extends DiscoverContentUseCase {
  DiscoverContentUseCaseImpl({required this.repository});

  final HomeRepository repository;

  @override
  Future<MoviesEntity> getDiscoverContent({
    required int page,
    required String apiKey,
    required String language,
    required String category,
    String? region,
    bool? includeAdult,
    bool? includeVideo,
    String? certification,
    int? primaryReleaseYear,
    String? certificationGte,
    String? certificationLte,
    String? certificationCountry,
  }) async {
    return repository.getDiscoverContent(
      page,
      apiKey,
      language,
      category,
      region,
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
