import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../../../features/common/common.dart';
import '../../../../movies/domain/models/movies_entity.dart';
import '../../../domain/usecases/airing_today/airing_today_tv_shows_use_case.dart';

part 'airing_today_tv_shows_event.dart';

part 'airing_today_tv_shows_state.dart';

class AiringTodayTvShowsBloc extends Bloc<UiEvent, UiState> {
  AiringTodayTvShowsBloc(this.airingTodayTvShowsUseCase)
    : super(AiringTodayTvShowsInitial()) {
    on<LoadAiringTodayTvShows>(_load);
    on<ToggleSection>(_onToggleSection);
  }

  final AiringTodayTvShowsUseCase airingTodayTvShowsUseCase;

  Future<void> _load(LoadAiringTodayTvShows event, Emitter<UiState> emit) async {
    try {
      if (state is! AiringTodayTvShowsLoaded) {
        emit(AiringTodayTvShowsLoading());
      }
      final airingTodayTvShows = await airingTodayTvShowsUseCase.getAiringTodayTvShows(
        1,
        'bc0abeeb117c70b4a31a9b439dd7e981',
        'US',
        'us-US',
      );
      emit(
        AiringTodayTvShowsLoaded(airingTodayTvShows: airingTodayTvShows, isExpanded: false),
      );
    } catch (e, st) {
      emit(AiringTodayTvShowsLoadingFailure(exception: e));
      GetIt.I<Talker>().handle(e, st);
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _onToggleSection(
    ToggleSection event,
    Emitter<UiState> emit,
  ) async {
    if (state is AiringTodayTvShowsLoaded) {
      final currentState = state as AiringTodayTvShowsLoaded;
      // Emit new state with toggled isExpanded (TvShows list remains same)
      emit(
        AiringTodayTvShowsLoaded(
          airingTodayTvShows: currentState.airingTodayTvShows,
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
