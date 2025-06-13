part of 'top_rated_movies_bloc.dart';

class LoadTopRatedMovies extends MoviesEvent {
  LoadTopRatedMovies({
    this.completer
  });
  final Completer? completer;

  @override
  // TODO: implement props
  List<Object?> get props => [completer];
}

class ToggleTopRatedSection extends MoviesEvent {
  ToggleTopRatedSection({
    this.completer
  });
  final Completer? completer;

  @override
  // TODO: implement props
  List<Object?> get props => [completer];
}