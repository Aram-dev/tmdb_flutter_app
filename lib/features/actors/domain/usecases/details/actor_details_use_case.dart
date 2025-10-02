import '../../models/actor_details.dart';

abstract class ActorDetailsUseCase {
  Future<ActorDetails> fetchActorDetails({
    required int actorId,
    required String apiKey,
    String language = 'en-US',
  });
}
