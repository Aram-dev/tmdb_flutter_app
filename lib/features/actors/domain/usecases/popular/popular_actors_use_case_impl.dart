import '../../models/actors_list_entity.dart';
import '../../repositories/actors_repository.dart';
import '../../usecases/popular/popular_actors_use_case.dart';

class PopularActorsUseCaseImpl extends PopularActorsUseCase {
  PopularActorsUseCaseImpl({required this.repository});

  final ActorsRepository repository;

  @override
  Future<ActorsListEntity> getPopularActors(
    int page,
    String language,
  ) async {
    return repository.getPopularActors(page, language);
  }
}
