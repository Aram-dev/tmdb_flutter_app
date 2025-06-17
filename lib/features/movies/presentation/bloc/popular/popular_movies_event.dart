part of 'popular_movies_bloc.dart';

class LoadPopularMovies extends MoviesEvent {
  LoadPopularMovies({
    this.completer
  });
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}

class TogglePopularSection extends MoviesEvent {
  TogglePopularSection({
    this.completer
  });
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}