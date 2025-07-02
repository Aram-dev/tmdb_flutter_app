part of 'trending_movies_bloc.dart';

class TrendingMoviesInitial extends UiState {
  @override
  List<Object?> get props => [];
}

class TrendingMoviesLoading extends UiState {
  @override
  List<Object?> get props => [];
}

class TrendingMoviesLoaded extends UiState {
  TrendingMoviesLoaded({
    required this.trendingMovies, required this.currentWindow, required this.isExpanded
  });
  final MovieTvShowEntity trendingMovies;
  final String currentWindow;
  final bool isExpanded;

  @override
  List<Object?> get props => [trendingMovies, currentWindow, isExpanded];
}

class TrendingMoviesLoadingFailure extends UiState {
  TrendingMoviesLoadingFailure({
    required this.exception
  });
  final Object? exception;

  @override
  List<Object?> get props => [exception];

}