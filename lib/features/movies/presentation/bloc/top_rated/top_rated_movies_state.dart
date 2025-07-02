part of 'top_rated_movies_bloc.dart';

class TopRatedMoviesInitial extends UiState {
  @override
  List<Object?> get props => [];
}

class TopRatedMoviesLoading extends UiState {
  @override
  List<Object?> get props => [];
}

class TopRatedMoviesLoaded extends UiState {
  TopRatedMoviesLoaded({
    required this.topRatedMovies, required this.isExpanded
  });
  final MovieTvShowEntity topRatedMovies;
  bool isExpanded = false;

  @override
  List<Object?> get props => [topRatedMovies, isExpanded];
}

class TopRatedMoviesLoadingFailure extends UiState {
  TopRatedMoviesLoadingFailure({
    required this.exception
  });
  final Object? exception;

  @override
  List<Object?> get props => [exception];

}