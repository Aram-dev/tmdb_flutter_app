import 'package:tmdb_flutter_app/features/actors/domain/models/actors_list_entity.dart';

abstract class PopularActorsUseCase {
  Future<ActorsListEntity> getPopularActors(
    int page,
    String apiKey,
    String language,
  );
}
