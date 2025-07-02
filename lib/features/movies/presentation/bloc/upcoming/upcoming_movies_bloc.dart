import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:tmdb_flutter_app/features/movies/domain/usecases/usecases.dart';

import '../../../../common/common.dart';

part 'upcoming_movies_event.dart';

part 'upcoming_movies_state.dart';

class UpcomingMoviesBloc
    extends Bloc<UiEvent, UiState> {
  UpcomingMoviesBloc(this.upcomingMoviesUseCase)
    : super(UpcomingMoviesInitial()) {
    on<LoadUpcomingMovies>(_load);
    on<ToggleSection>(_onToggleSection);
  }

  final UpcomingMoviesUseCase upcomingMoviesUseCase;

  Future<void> _load(
    LoadUpcomingMovies event,
    Emitter<UiState> emit,
  ) async {
    try {
      if (state is! UpcomingMoviesLoaded) {
        emit(UpcomingMoviesLoading());
      }
      final upcomingMovies = await upcomingMoviesUseCase
          .getUpcomingMovies(1, 'bc0abeeb117c70b4a31a9b439dd7e981', 'US', 'us-US');
      emit(UpcomingMoviesLoaded(upcomingMovies: upcomingMovies, isExpanded: false));
    } catch (e, st) {
      emit(UpcomingMoviesLoadingFailure(exception: e));
      GetIt.I<Talker>().handle(e, st);
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _onToggleSection(
      ToggleSection event,
      Emitter<UiState> emit,
      ) async {
    if (state is UpcomingMoviesLoaded) {
      final currentState = state as UpcomingMoviesLoaded;
      // Emit new state with toggled isExpanded (movies list remains same)
      emit(
        UpcomingMoviesLoaded(
          upcomingMovies: currentState.upcomingMovies,
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
