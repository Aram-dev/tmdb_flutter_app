import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../../../features/common/common.dart';
import '../../../../movies/domain/models/movies_entity.dart';
import '../../../domain/usecases/popular/popular_tv_shows_use_case.dart';

part 'popular_tv_shows_event.dart';

part 'popular_tv_shows_state.dart';

class PopularTvShowsBloc extends Bloc<UiEvent, UiState> {
  PopularTvShowsBloc(this.popularTvShowsUseCase)
    : super(PopularTvShowsInitial()) {
    on<LoadPopularTvShows>(_load);
    on<ToggleSection>(_onToggleSection);
  }

  final PopularTvShowsUseCase popularTvShowsUseCase;

  Future<void> _load(LoadPopularTvShows event, Emitter<UiState> emit) async {
    try {
      if (state is! PopularTvShowsLoaded) {
        emit(PopularTvShowsLoading());
      }
      final popularTvShows = await popularTvShowsUseCase.getPopularTvShows(
        1,
        'bc0abeeb117c70b4a31a9b439dd7e981',
        'US',
        'us-US',
      );
      emit(
        PopularTvShowsLoaded(popularTvShows: popularTvShows, isExpanded: false),
      );
    } catch (e, st) {
      emit(PopularTvShowsLoadingFailure(exception: e));
      GetIt.I<Talker>().handle(e, st);
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _onToggleSection(
    ToggleSection event,
    Emitter<UiState> emit,
  ) async {
    if (state is PopularTvShowsLoaded) {
      final currentState = state as PopularTvShowsLoaded;
      // Emit new state with toggled isExpanded (TvShows list remains same)
      emit(
        PopularTvShowsLoaded(
          popularTvShows: currentState.popularTvShows,
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
