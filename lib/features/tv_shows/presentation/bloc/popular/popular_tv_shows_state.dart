part of 'popular_tv_shows_bloc.dart';

class PopularTvShowsInitial extends UiState {
  @override
  List<Object?> get props => [];
}

class PopularTvShowsLoading extends UiState {
  @override
  List<Object?> get props => [];
}

class PopularTvShowsLoaded extends UiState {
  PopularTvShowsLoaded({
    required this.popularTvShows, required this.isExpanded
  });
  final MovieTvShowEntity popularTvShows;
  bool isExpanded = false;

  @override
  List<Object?> get props => [popularTvShows, isExpanded];
}

class PopularTvShowsLoadingFailure extends UiState {
  PopularTvShowsLoadingFailure({
    required this.exception
  });
  final Object? exception;

  @override
  List<Object?> get props => [exception];

}