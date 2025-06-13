part of 'popular_movies_bloc.dart';

class PopularMoviesInitial extends MoviesState {
  @override
  List<Object?> get props => [];
}

class PopularMoviesLoading extends MoviesState {
  @override
  List<Object?> get props => [];
}

class PopularMoviesLoaded extends MoviesState {
  PopularMoviesLoaded({
    required this.popularMovies, required this.isExpanded
  });
  final MoviesEntity popularMovies;
  bool isExpanded = false;

  @override
  List<Object?> get props => [popularMovies, isExpanded];
}

class PopularMoviesLoadingFailure extends MoviesState {
  PopularMoviesLoadingFailure({
    required this.exception
  });
  final Object? exception;

  @override
  List<Object?> get props => [exception];

}