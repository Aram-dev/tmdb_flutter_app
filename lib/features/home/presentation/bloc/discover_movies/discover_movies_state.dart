part of 'discover_movies_bloc.dart';

class DiscoverMoviesInitial extends UiState {
  @override
  List<Object?> get props => [];
}

class DiscoverContentLoading extends UiState {
  @override
  List<Object?> get props => [];
}

class DiscoverContentLoaded extends UiState {
  DiscoverContentLoaded({
    required this.discoverMovies, required this.isExpanded
  });
  final MovieTvShowEntity discoverMovies;
  bool isExpanded = false;

  @override
  List<Object?> get props => [discoverMovies, isExpanded];
}

class DiscoverContentLoadingFailure extends UiState {
  DiscoverContentLoadingFailure({
    required this.exception
  });
  final Object? exception;

  @override
  List<Object?> get props => [exception];

}