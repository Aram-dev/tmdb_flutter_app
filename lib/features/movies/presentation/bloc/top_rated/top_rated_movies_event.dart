part of 'top_rated_movies_bloc.dart';

class LoadTopRatedMovies extends UiEvent {
  LoadTopRatedMovies({
    this.completer
  });
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}

class ToggleTopRatedSection extends UiEvent {
  ToggleTopRatedSection({
    this.completer
  });
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}