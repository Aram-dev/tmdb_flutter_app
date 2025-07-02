part of 'top_rated_tv_shows_bloc.dart';

class TopRatedTvShowsInitial extends UiState {
  @override
  List<Object?> get props => [];
}

class TopRatedTvShowsLoading extends UiState {
  @override
  List<Object?> get props => [];
}

class TopRatedTvShowsLoaded extends UiState {
  TopRatedTvShowsLoaded({
    required this.topRatedTvShows, required this.isExpanded
  });
  final MovieTvShowEntity topRatedTvShows;
  bool isExpanded = false;

  @override
  List<Object?> get props => [topRatedTvShows, isExpanded];
}

class TopRatedTvShowsLoadingFailure extends UiState {
  TopRatedTvShowsLoadingFailure({
    required this.exception
  });
  final Object? exception;

  @override
  List<Object?> get props => [exception];

}