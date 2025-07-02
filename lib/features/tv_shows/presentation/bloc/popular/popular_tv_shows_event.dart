part of 'popular_tv_shows_bloc.dart';

class LoadPopularTvShows extends UiEvent {
  LoadPopularTvShows({
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