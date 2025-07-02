part of 'airing_today_tv_shows_bloc.dart';

class AiringTodayTvShowsInitial extends UiState {
  @override
  List<Object?> get props => [];
}

class AiringTodayTvShowsLoading extends UiState {
  @override
  List<Object?> get props => [];
}

class AiringTodayTvShowsLoaded extends UiState {
  AiringTodayTvShowsLoaded({
    required this.airingTodayTvShows, required this.isExpanded
  });
  final MovieTvShowEntity airingTodayTvShows;
  bool isExpanded = false;

  @override
  List<Object?> get props => [airingTodayTvShows, isExpanded];
}

class AiringTodayTvShowsLoadingFailure extends UiState {
  AiringTodayTvShowsLoadingFailure({
    required this.exception
  });
  final Object? exception;

  @override
  List<Object?> get props => [exception];

}