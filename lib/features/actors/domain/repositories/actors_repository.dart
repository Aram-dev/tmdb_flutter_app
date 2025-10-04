import '../models/actor_details.dart';
import '../models/actors_list_entity.dart';

abstract class ActorsRepository {
  Future<ActorsListEntity> getPopularActors(
    int page,
    String language,
  );

  Future<ActorDetails> getActorDetails(
    int actorId,
    String language,
  );
}
