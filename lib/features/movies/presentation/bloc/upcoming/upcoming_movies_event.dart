part of 'upcoming_movies_bloc.dart';

class LoadUpcomingMovies extends UiEvent {
  LoadUpcomingMovies({
    this.completer
  });
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}

class ToggleUpcomingSection extends UiEvent {
  ToggleUpcomingSection({
    this.completer
  });
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}