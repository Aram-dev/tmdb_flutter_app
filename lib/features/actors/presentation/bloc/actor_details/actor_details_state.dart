part of 'actor_details_bloc.dart';

class ActorDetailsInitial extends UiState {
  const ActorDetailsInitial({this.initialActor});

  final ActorsListResults? initialActor;

  @override
  List<Object?> get props => [initialActor];
}

class ActorDetailsLoading extends UiState {
  const ActorDetailsLoading({this.initialActor});

  final ActorsListResults? initialActor;

  @override
  List<Object?> get props => [initialActor];
}

class ActorDetailsLoaded extends UiState {
  const ActorDetailsLoaded({required this.details});

  final ActorDetails details;

  @override
  List<Object?> get props => [details];
}

class ActorDetailsFailure extends UiState {
  const ActorDetailsFailure({
    required this.exception,
    this.initialActor,
  });

  final Object exception;
  final ActorsListResults? initialActor;

  @override
  List<Object?> get props => [exception, initialActor];
}
