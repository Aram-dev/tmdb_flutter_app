import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:tmdb_flutter_app/features/movies/domain/usecases/usecases.dart';

import '../../../../common/common.dart';
import 'package:tmdb_flutter_app/features/auth/domain/repositories/auth_repository.dart';

part 'top_rated_movies_event.dart';

part 'top_rated_movies_state.dart';

class TopRatedMoviesBloc extends Bloc<UiEvent, UiState> {
  TopRatedMoviesBloc(this.topRatedMoviesUseCase, this.authRepository)
    : super(TopRatedMoviesInitial()) {
    on<LoadTopRatedMovies>(_load);
    on<ToggleSection>(_onToggleSection);
  }

  final TopRatedMoviesUseCase topRatedMoviesUseCase;
  final AuthRepository authRepository;

  Future<void> _load(
    LoadTopRatedMovies event,
    Emitter<UiState> emit,
  ) async {
    try {
      if (state is! TopRatedMoviesLoaded) {
        emit(TopRatedMoviesLoading());
      }
      final apiKey = await authRepository.requireApiKey();
      final topRatedMovies = await topRatedMoviesUseCase
          .getTopRatedMovies(1, apiKey, 'US', 'us-US');
      emit(TopRatedMoviesLoaded(topRatedMovies: topRatedMovies, isExpanded: false));
    } catch (e, st) {
      emit(TopRatedMoviesLoadingFailure(exception: e));
      GetIt.I<Talker>().handle(e, st);
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _onToggleSection(
      ToggleSection event,
      Emitter<UiState> emit,
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
