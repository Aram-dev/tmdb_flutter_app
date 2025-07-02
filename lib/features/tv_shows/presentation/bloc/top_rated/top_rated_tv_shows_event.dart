part of 'top_rated_tv_shows_bloc.dart';

class LoadTopRatedTvShows extends UiEvent {
  LoadTopRatedTvShows({
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