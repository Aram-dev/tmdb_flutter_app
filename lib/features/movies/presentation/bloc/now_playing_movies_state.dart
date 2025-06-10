part of 'now_playing_movies_bloc.dart';

abstract class NowPlayingMoviesState extends Equatable {}

class NowPlayingMoviesInitial extends NowPlayingMoviesState {
  @override
  List<Object?> get props => [];
}

class NowPlayingMoviesLoading extends NowPlayingMoviesState {
  @override
  List<Object?> get props => [];
}

class NowPlayingMoviesLoaded extends NowPlayingMoviesState {
  NowPlayingMoviesLoaded({
    required this.nowPlayingMovies
  });
  final NowPlayingEntity nowPlayingMovies;

  @override
  List<Object?> get props => [nowPlayingMovies];
}

class NowPlayingMoviesLoadingFailure extends NowPlayingMoviesState {
  NowPlayingMoviesLoadingFailure({
    required this.exception
  });
  final Object? exception;

  @override
  List<Object?> get props => [exception];

}