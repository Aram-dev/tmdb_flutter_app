part of 'top_rated_movies_bloc.dart';

class TopRatedMoviesInitial extends MoviesState {
  @override
  List<Object?> get props => [];
}

class TopRatedMoviesLoading extends MoviesState {
  @override
  List<Object?> get props => [];
}

class TopRatedMoviesLoaded extends MoviesState {
  TopRatedMoviesLoaded({
    required this.topRatedMovies, required this.isExpanded
  });
  final MoviesEntity topRatedMovies;
  bool isExpanded = false;

  @override
  List<Object?> get props => [topRatedMovies, isExpanded];
}

class TopRatedMoviesLoadingFailure extends MoviesState {
  TopRatedMoviesLoadingFailure({
    required this.exception
  });
  final Object? exception;

  @override
  List<Object?> get props => [exception];

}