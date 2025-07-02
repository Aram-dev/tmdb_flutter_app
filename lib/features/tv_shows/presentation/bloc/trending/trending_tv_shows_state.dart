part of 'trending_tv_shows_bloc.dart';

class TrendingTvShowsInitial extends UiState {
  @override
  List<Object?> get props => [];
}

class TrendingTvShowsLoading extends UiState {
  @override
  List<Object?> get props => [];
}

class TrendingTvShowsLoaded extends UiState {
  TrendingTvShowsLoaded({
    required this.trendingContent, required this.currentWindow, required this.isExpanded
  });
  final MovieTvShowEntity trendingContent;
  final String currentWindow;
  final bool isExpanded;

  @override
  List<Object?> get props => [trendingContent, currentWindow, isExpanded];
}

class TrendingTvShowsLoadingFailure extends UiState {
  TrendingTvShowsLoadingFailure({
    required this.exception
  });
  final Object? exception;

  @override
  List<Object?> get props => [exception];

}