part of 'now_playing_movies_bloc.dart';

class LoadNowPlayingMovies extends UiEvent {
  LoadNowPlayingMovies({
    this.completer
  });
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}

class ToggleNowPlayingSection extends UiEvent {
  ToggleNowPlayingSection({
    this.completer
  });
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}