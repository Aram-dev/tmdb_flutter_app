part of 'now_playing_movies_bloc.dart';

class LoadNowPlayingMovies extends MoviesEvent {
  LoadNowPlayingMovies({
    this.completer
  });
  final Completer? completer;

  @override
  // TODO: implement props
  List<Object?> get props => [completer];
}

class ToggleNowPlayingSection extends MoviesEvent {
  ToggleNowPlayingSection({
    this.completer
  });
  final Completer? completer;

  @override
  // TODO: implement props
  List<Object?> get props => [completer];
}