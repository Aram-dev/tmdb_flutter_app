import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:tmdb_flutter_app/features/movies/domain/usecases/usecases.dart';

import '../../../../common/common.dart';

part 'now_playing_movies_event.dart';

part 'now_playing_movies_state.dart';

class NowPlayingMoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  NowPlayingMoviesBloc(this.nowPlayingMoviesUseCase)
    : super(NowPlayingMoviesInitial()) {
    on<LoadNowPlayingMovies>(_load);
    on<ToggleSection>(_onToggleSection);
  }

  final NowPlayingMoviesUseCase nowPlayingMoviesUseCase;

  Future<void> _load(
    LoadNowPlayingMovies event,
    Emitter<MoviesState> emit,
  ) async {
    try {
      if (state is! NowPlayingMoviesLoaded) {
        emit(NowPlayingMoviesLoading());
      }
      final nowPlayingMovies = await nowPlayingMoviesUseCase
          .getNowPlayingMovies(
            1,
            'bc0abeeb117c70b4a31a9b439dd7e981',
            'US',
            'us-US',
          );
      emit(
        NowPlayingMoviesLoaded(
          nowPlayingMovies: nowPlayingMovies,
          isExpanded: false,
        ),
      );
    } catch (e, st) {
      emit(NowPlayingMoviesLoadingFailure(exception: e));
      GetIt.I<Talker>().handle(e, st);
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _onToggleSection(
      ToggleSection event,
    Emitter<MoviesState> emit,
  ) async {
    if (state is NowPlayingMoviesLoaded) {
      final currentState = state as NowPlayingMoviesLoaded;
      // Emit new state with toggled isExpanded (movies list remains same)
      emit(
        NowPlayingMoviesLoaded(
          nowPlayingMovies: currentState.nowPlayingMovies,
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
