part of 'upcoming_movies_bloc.dart';

class UpcomingMoviesInitial extends MoviesState {
  @override
  List<Object?> get props => [];
}

class UpcomingMoviesLoading extends MoviesState {
  @override
  List<Object?> get props => [];
}

class UpcomingMoviesLoaded extends MoviesState {
  UpcomingMoviesLoaded({
    required this.upcomingMovies, required this.isExpanded
  });
  final MoviesEntity upcomingMovies;
  bool isExpanded = false;

  @override
  List<Object?> get props => [upcomingMovies, isExpanded];
}

class UpcomingMoviesLoadingFailure extends MoviesState {
  UpcomingMoviesLoadingFailure({
    required this.exception
  });
  final Object? exception;

  @override
  List<Object?> get props => [exception];

}