import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:tmdb_flutter_app/features/movies/domain/usecases/usecases.dart';
import '../../../../common/common.dart';
import 'package:tmdb_flutter_app/features/auth/domain/repositories/auth_repository.dart';

part 'popular_movies_event.dart';

part 'popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<UiEvent, UiState> {
  PopularMoviesBloc(this.popularMoviesUseCase, this.authRepository)
      : super(PopularMoviesInitial()) {
    on<LoadPopularMovies>(_load);
    on<ToggleSection>(_onToggleSection);
  }

  final PopularMoviesUseCase popularMoviesUseCase;
  final AuthRepository authRepository;

  Future<void> _load(LoadPopularMovies event, Emitter<UiState> emit) async {
    try {
      if (state is! PopularMoviesLoaded) {
        emit(PopularMoviesLoading());
      }
      final apiKey = await authRepository.requireApiKey();
      final popularMovies = await popularMoviesUseCase.getPopularMovies(
        1,
        apiKey,
        'US',
        'us-US',
      );
      emit(
        PopularMoviesLoaded(popularMovies: popularMovies, isExpanded: false),
      );
    } catch (e, st) {
      emit(PopularMoviesLoadingFailure(exception: e));
      GetIt.I<Talker>().handle(e, st);
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _onToggleSection(
    ToggleSection event,
    Emitter<UiState> emit,
  ) async {
    if (state is PopularMoviesLoaded) {
      final currentState = state as PopularMoviesLoaded;
      // Emit new state with toggled isExpanded (movies list remains same)
      emit(
        PopularMoviesLoaded(
          popularMovies: currentState.popularMovies,
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
