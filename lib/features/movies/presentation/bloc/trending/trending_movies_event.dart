part of 'trending_movies_bloc.dart';

class LoadTrendingMovies extends MoviesEvent {
  LoadTrendingMovies({
    this.completer, required this.selectedWindow
  });
  final Completer? completer;
  String selectedWindow;

  @override
  // TODO: implement props
  List<Object?> get props => [completer, selectedWindow];
}