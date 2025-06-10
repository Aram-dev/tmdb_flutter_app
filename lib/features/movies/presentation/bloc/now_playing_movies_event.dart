part of 'now_playing_movies_bloc.dart';

abstract class NowPlayingMoviesEvent extends Equatable {}

class LoadNowPlayingMovies extends NowPlayingMoviesEvent {
  LoadNowPlayingMovies({
    this.completer
  });
  final Completer? completer;

  @override
  // TODO: implement props
  List<Object?> get props => [completer];
}