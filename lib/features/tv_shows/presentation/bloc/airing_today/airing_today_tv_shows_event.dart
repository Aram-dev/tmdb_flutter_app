part of 'airing_today_tv_shows_bloc.dart';

class LoadAiringTodayTvShows extends UiEvent {
  LoadAiringTodayTvShows({
    this.completer
  });
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}

class ToggleAiringTodaySection extends UiEvent {
  ToggleAiringTodaySection({
    this.completer
  });
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}