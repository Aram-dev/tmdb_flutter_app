part of 'upcoming_movies_bloc.dart';

class UpcomingMoviesInitial extends UiState {
  @override
  List<Object?> get props => [];
}

class UpcomingMoviesLoading extends UiState {
  @override
  List<Object?> get props => [];
}

class UpcomingMoviesLoaded extends UiState {
  UpcomingMoviesLoaded({
    required this.upcomingMovies, required this.isExpanded
  });
  final MovieTvShowEntity upcomingMovies;
  bool isExpanded = false;

  @override
  List<Object?> get props => [upcomingMovies, isExpanded];
}

class UpcomingMoviesLoadingFailure extends UiState {
  UpcomingMoviesLoadingFailure({
    required this.exception
  });
  final Object? exception;

  @override
  List<Object?> get props => [exception];

}