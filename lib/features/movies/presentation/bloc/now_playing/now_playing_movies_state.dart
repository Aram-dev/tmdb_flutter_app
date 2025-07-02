part of 'now_playing_movies_bloc.dart';

class NowPlayingMoviesInitial extends UiState {
  @override
  List<Object?> get props => [];
}

class NowPlayingMoviesLoading extends UiState {
  @override
  List<Object?> get props => [];
}

class NowPlayingMoviesLoaded extends UiState {
  NowPlayingMoviesLoaded({
    required this.nowPlayingMovies, required this.isExpanded
  });
  final MovieTvShowEntity nowPlayingMovies;
  bool isExpanded = false;

  @override
  List<Object?> get props => [nowPlayingMovies, isExpanded];
}

class NowPlayingMoviesLoadingFailure extends UiState {
  NowPlayingMoviesLoadingFailure({
    required this.exception
  });
  final Object? exception;

  @override
  List<Object?> get props => [exception];

}