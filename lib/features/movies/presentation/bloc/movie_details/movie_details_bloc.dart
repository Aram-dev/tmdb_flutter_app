import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:tmdb_flutter_app/features/movies/domain/usecases/usecases.dart';

import '../../../../common/common.dart';
import '../../../domain/models/movie_credits.dart';
import '../../../domain/models/movie_detail.dart';
import '../../../domain/models/movie_recommendations.dart';
import '../../../domain/models/movie_reviews.dart';
import '../../../domain/models/movie_watch_providers.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  MovieDetailsBloc({
    required this.movieDetailsUseCase,
    required this.movieCreditsUseCase,
    required this.movieReviewsUseCase,
    required this.movieRecommendationsUseCase,
    required this.movieWatchProvidersUseCase,
  }) : super(MovieDetailsInitial()) {
    on<LoadMovieDetails>(_onLoad);
  }

  final MovieDetailsUseCase movieDetailsUseCase;
  final MovieCreditsUseCase movieCreditsUseCase;
  final MovieReviewsUseCase movieReviewsUseCase;
  final MovieRecommendationsUseCase movieRecommendationsUseCase;
  final MovieWatchProvidersUseCase movieWatchProvidersUseCase;

  Future<void> _onLoad(
    LoadMovieDetails event,
    Emitter<MovieDetailsState> emit,
  ) async {
    emit(MovieDetailsLoading());
    try {
      final language = event.language ?? 'en-US';
      final region = event.region ?? 'US';

      final detail = await movieDetailsUseCase.getMovieDetails(
        event.movieId,
        language,
      );
      final credits = await movieCreditsUseCase.getMovieCredits(
        event.movieId,
        language,
      );
      final reviews = await movieReviewsUseCase.getMovieReviews(
        event.movieId,
        language,
      );
      final recommendations =
          await movieRecommendationsUseCase.getMovieRecommendations(
        event.movieId,
        language,
      );
      final watchProviders =
          await movieWatchProvidersUseCase.getMovieWatchProviders(
        event.movieId,
        region,
      );

      emit(
        MovieDetailsLoaded(
          detail: detail,
          credits: credits,
          reviews: reviews,
          recommendations: recommendations,
          watchProviders: watchProviders,
        ),
      );
    } catch (e) {
      emit(MovieDetailsFailure(exception: e));
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
