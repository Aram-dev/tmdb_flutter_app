part of 'popular_actors_bloc.dart';

class LoadPopularActors extends UiEvent {
  LoadPopularActors({
    this.reset = false,
    this.completer
  });
  // When true we clear and reload from page 1
  final bool reset;
  final Completer? completer;

  @override
  List<Object?> get props => [completer, reset];
}