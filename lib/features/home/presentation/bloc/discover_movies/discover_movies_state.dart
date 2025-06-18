part of 'discover_movies_bloc.dart';

class DiscoverMoviesInitial extends MoviesState {
  @override
  List<Object?> get props => [];
}

class DiscoverContentLoading extends MoviesState {
  @override
  List<Object?> get props => [];
}

class DiscoverContentLoaded extends MoviesState {
  DiscoverContentLoaded({
    required this.discoverMovies, required this.isExpanded
  });
  final MoviesEntity discoverMovies;
  bool isExpanded = false;

  @override
  List<Object?> get props => [discoverMovies, isExpanded];
}

class DiscoverContentLoadingFailure extends MoviesState {
  DiscoverContentLoadingFailure({
    required this.exception
  });
  final Object? exception;

  @override
  List<Object?> get props => [exception];

}