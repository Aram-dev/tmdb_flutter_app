part of 'actor_details_bloc.dart';

class FetchActorDetails extends UiEvent {
  const FetchActorDetails({
    required this.actorId,
    this.initialActor,
  });

  final int actorId;
  final ActorsListResults? initialActor;

  @override
  List<Object?> get props => [actorId, initialActor];
}
