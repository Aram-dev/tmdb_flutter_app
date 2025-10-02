part of 'actor_details_bloc.dart';

abstract class ActorDetailsState extends UiState {
  const ActorDetailsState();
}

class ActorDetailsInitial extends ActorDetailsState {
  const ActorDetailsInitial();

  @override
  List<Object?> get props => const [];
}

class ActorDetailsLoading extends ActorDetailsState {
  const ActorDetailsLoading();

  @override
  List<Object?> get props => const [];
}

class ActorDetailsLoaded extends ActorDetailsState {
  const ActorDetailsLoaded({required this.actorDetails});

  final ActorDetails actorDetails;

  @override
  List<Object?> get props => [actorDetails];
}

class ActorDetailsFailure extends ActorDetailsState {
  const ActorDetailsFailure({required this.exception});

  final Object exception;

  @override
  List<Object?> get props => [exception];
}
