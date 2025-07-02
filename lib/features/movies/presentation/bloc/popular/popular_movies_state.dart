part of 'popular_movies_bloc.dart';

class PopularMoviesInitial extends UiState {
  @override
  List<Object?> get props => [];
}

class PopularMoviesLoading extends UiState {
  @override
  List<Object?> get props => [];
}

class PopularMoviesLoaded extends UiState {
  PopularMoviesLoaded({
    required this.popularMovies, required this.isExpanded
  });
  final MovieTvShowEntity popularMovies;
  bool isExpanded = false;

  @override
  List<Object?> get props => [popularMovies, isExpanded];
}

class PopularMoviesLoadingFailure extends UiState {
  PopularMoviesLoadingFailure({
    required this.exception
  });
  final Object? exception;

  @override
  List<Object?> get props => [exception];

}