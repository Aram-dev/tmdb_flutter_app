part of 'movie_details_bloc.dart';

abstract class MovieDetailsState extends UiState {
  MovieDetailsState();

  @override
  List<Object?> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {
  MovieDetailsInitial();
}

class MovieDetailsLoading extends MovieDetailsState {
  MovieDetailsLoading();
}

class MovieDetailsLoaded extends MovieDetailsState {
  MovieDetailsLoaded({
    required this.detail,
    required this.credits,
    required this.reviews,
    required this.recommendations,
    required this.watchProviders,
  });

  final MovieDetail detail;
  final MovieCredits credits;
  final MovieReviews reviews;
  final MovieRecommendations recommendations;
  final MovieWatchProviders watchProviders;

  @override
  List<Object?> get props => [
        detail,
        credits,
        reviews,
        recommendations,
        watchProviders,
      ];
}

class MovieDetailsFailure extends MovieDetailsState {
  MovieDetailsFailure({required this.exception});

  final Object exception;

  @override
  List<Object?> get props => [exception];
}
