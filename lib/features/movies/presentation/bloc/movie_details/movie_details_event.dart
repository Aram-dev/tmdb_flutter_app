part of 'movie_details_bloc.dart';

abstract class MovieDetailsEvent extends UiEvent {
  MovieDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadMovieDetails extends MovieDetailsEvent {
  LoadMovieDetails({
    required this.movieId,
    this.language,
    this.region,
  });

  final int movieId;
  final String? language;
  final String? region;

  @override
  List<Object?> get props => [movieId, language, region];
}
