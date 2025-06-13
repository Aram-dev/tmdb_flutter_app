part of 'trending_movies_bloc.dart';

class TrendingMoviesInitial extends MoviesState {
  @override
  List<Object?> get props => [];
}

class TrendingMoviesLoading extends MoviesState {
  @override
  List<Object?> get props => [];
}

class TrendingMoviesLoaded extends MoviesState {
  TrendingMoviesLoaded({
    required this.trendingMovies, required this.currentWindow, required this.isExpanded
  });
  final MoviesEntity trendingMovies;
  String currentWindow;
  bool isExpanded = false;

  @override
  List<Object?> get props => [trendingMovies, currentWindow, isExpanded];
}

class TrendingMoviesLoadingFailure extends MoviesState {
  TrendingMoviesLoadingFailure({
    required this.exception
  });
  final Object? exception;

  @override
  List<Object?> get props => [exception];

}