part of 'now_playing_movies_bloc.dart';

class NowPlayingMoviesInitial extends MoviesState {
  @override
  List<Object?> get props => [];
}

class NowPlayingMoviesLoading extends MoviesState {
  @override
  List<Object?> get props => [];
}

class NowPlayingMoviesLoaded extends MoviesState {
  NowPlayingMoviesLoaded({
    required this.nowPlayingMovies, required this.isExpanded
  });
  final MoviesEntity nowPlayingMovies;
  bool isExpanded = false;

  @override
  List<Object?> get props => [nowPlayingMovies, isExpanded];
}

class NowPlayingMoviesLoadingFailure extends MoviesState {
  NowPlayingMoviesLoadingFailure({
    required this.exception
  });
  final Object? exception;

  @override
  List<Object?> get props => [exception];

}