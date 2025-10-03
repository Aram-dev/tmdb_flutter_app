part of 'actor_details_bloc.dart';

abstract class ActorDetailsEvent extends UiEvent {
  ActorDetailsEvent();
}

class LoadActorDetails extends ActorDetailsEvent {
  LoadActorDetails({required this.actorId, this.language});

  final int actorId;
  final String? language;

  @override
  List<Object?> get props => [actorId, language];
}
