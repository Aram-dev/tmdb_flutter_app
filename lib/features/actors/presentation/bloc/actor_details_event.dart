part of 'actor_details_bloc.dart';

class LoadActorDetails extends UiEvent {
  LoadActorDetails({required this.actorId, this.language});

  final int actorId;
  final String? language;

  @override
  List<Object?> get props => [actorId, language];
}
