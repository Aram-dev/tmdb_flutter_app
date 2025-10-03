part of 'actor_details_bloc.dart';

abstract class ActorDetailsState extends UiState {
  ActorDetailsState();
}

class ActorDetailsInitial extends ActorDetailsState {
  ActorDetailsInitial();

  @override
  List<Object?> get props => const [];
}

class ActorDetailsLoading extends ActorDetailsState {
  ActorDetailsLoading();

  @override
  List<Object?> get props => const [];
}

class ActorDetailsLoaded extends ActorDetailsState {
  ActorDetailsLoaded({required this.actorDetails});

  final ActorDetails actorDetails;

  @override
  List<Object?> get props => [actorDetails];
}

class ActorDetailsFailure extends ActorDetailsState {
  ActorDetailsFailure({required this.exception});

  final Object exception;

  @override
  List<Object?> get props => [exception];
}
