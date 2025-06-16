part of 'trending_movies_bloc.dart';

class LoadTrendingMovies extends MoviesEvent {
  LoadTrendingMovies({
    this.completer, required this.selectedWindow
  });
  final Completer? completer;
  final String selectedWindow;

  @override
  List<Object?> get props => [completer, selectedWindow];
}