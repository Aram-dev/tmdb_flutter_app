import '../../models/actor_details.dart';

abstract class ActorDetailsUseCase {
  Future<ActorDetails> getActorDetails(
    int actorId,
    String apiKey,
    String language,
  );
}
