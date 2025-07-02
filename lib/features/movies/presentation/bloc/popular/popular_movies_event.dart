part of 'popular_movies_bloc.dart';

class LoadPopularMovies extends UiEvent {
  LoadPopularMovies({
    this.completer
  });
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}

class TogglePopularSection extends UiEvent {
  TogglePopularSection({
    this.completer
  });
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}