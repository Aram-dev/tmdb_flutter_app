import '../../models/actor_details.dart';
import '../../repositories/actors_repository.dart';
import 'actor_details_use_case.dart';

class ActorDetailsUseCaseImpl extends ActorDetailsUseCase {
  ActorDetailsUseCaseImpl({required this.repository});

  final ActorsRepository repository;

  @override
  Future<ActorDetails> fetchActorDetails({
    required int actorId,
    required String apiKey,
    String language = 'en-US',
  }) {
    return repository.getActorDetails(actorId, apiKey, language);
  }
}
