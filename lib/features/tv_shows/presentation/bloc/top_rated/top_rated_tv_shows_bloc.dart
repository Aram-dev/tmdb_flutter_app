import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../../common/common.dart';
import '../../../../movies/domain/models/movies_entity.dart';
import '../../../domain/usecases/top_rated/top_rated_tv_shows_use_case.dart';

part 'top_rated_tv_shows_event.dart';

part 'top_rated_tv_shows_state.dart';

class TopRatedTvShowsBloc extends Bloc<UiEvent, UiState> {
  TopRatedTvShowsBloc(this.topRatedTvShowsUseCase)
    : super(TopRatedTvShowsInitial()) {
    on<LoadTopRatedTvShows>(_load);
    on<ToggleSection>(_onToggleSection);
  }

  final TopRatedTvShowsUseCase topRatedTvShowsUseCase;

  Future<void> _load(LoadTopRatedTvShows event, Emitter<UiState> emit) async {
    try {
      if (state is! TopRatedTvShowsLoaded) {
        emit(TopRatedTvShowsLoading());
      }
      final topRatedTvShows = await topRatedTvShowsUseCase.getTopRatedTvShows(
        1,
        'US',
        'us-US',
      );
      emit(
        TopRatedTvShowsLoaded(
          topRatedTvShows: topRatedTvShows,
          isExpanded: false,
        ),
      );
    } catch (e, st) {
      emit(TopRatedTvShowsLoadingFailure(exception: e));
      GetIt.I<Talker>().handle(e, st);
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _onToggleSection(
    ToggleSection event,
    Emitter<UiState> emit,
  ) async {
    if (state is TopRatedTvShowsLoaded) {
      final currentState = state as TopRatedTvShowsLoaded;
      // Emit new state with toggled isExpanded (TvShows list remains same)
      emit(
        TopRatedTvShowsLoaded(
          topRatedTvShows: currentState.topRatedTvShows,
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
