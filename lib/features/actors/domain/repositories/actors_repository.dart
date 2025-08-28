import '../models/actors_list_entity.dart';

abstract class ActorsRepository {
  Future<ActorsListEntity> getPopularActors(
    int page,
    String apiKey,
    String language,
  );
}
