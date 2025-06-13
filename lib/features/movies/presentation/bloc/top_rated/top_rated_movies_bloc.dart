import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:tmdb_flutter_app/features/movies/domain/usecases/usecases.dart';

import '../base/base.dart';

part 'top_rated_movies_event.dart';

part 'top_rated_movies_state.dart';

class TopRatedMoviesBloc
    extends Bloc<MoviesEvent, MoviesState> {
  TopRatedMoviesBloc(this.topRatedMoviesUseCase)
    : super(TopRatedMoviesInitial()) {
    on<LoadTopRatedMovies>(_load);
    on<ToggleTopRatedSection>(_onToggleSection);
  }

  final TopRatedMoviesUseCase topRatedMoviesUseCase;

  Future<void> _load(
    LoadTopRatedMovies event,
    Emitter<MoviesState> emit,
  ) async {
    try {
      if (state is! TopRatedMoviesLoaded) {
        emit(TopRatedMoviesLoading());
      }
      final topRatedMovies = await topRatedMoviesUseCase
          .getTopRatedMovies(1, 'bc0abeeb117c70b4a31a9b439dd7e981', 'US', 'us-US');
      emit(TopRatedMoviesLoaded(topRatedMovies: topRatedMovies, isExpanded: true));
    } catch (e, st) {
      emit(TopRatedMoviesLoadingFailure(exception: e));
      GetIt.I<Talker>().handle(e, st);
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _onToggleSection(
      ToggleTopRatedSection event,
      Emitter<MoviesState> emit,
      ) async {
    if (state is TopRatedMoviesLoaded) {
      final currentState = state as TopRatedMoviesLoaded;
      // Emit new state with toggled isExpanded (movies list remains same)
      emit(
        TopRatedMoviesLoaded(
          topRatedMovies: currentState.topRatedMovies,
          isExpanded: !currentState.isExpanded,
        ),
      );
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
