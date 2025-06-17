part of 'upcoming_movies_bloc.dart';

class LoadUpcomingMovies extends MoviesEvent {
  LoadUpcomingMovies({
    this.completer
  });
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}

class ToggleUpcomingSection extends MoviesEvent {
  ToggleUpcomingSection({
    this.completer
  });
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}