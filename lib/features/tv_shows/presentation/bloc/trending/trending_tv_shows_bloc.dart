import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../../common/common.dart';
import '../../../../movies/domain/models/movies_entity.dart';
import '../../../domain/usecases/trending/trending_tv_shows_use_case.dart';

part 'trending_tv_shows_event.dart';

part 'trending_tv_shows_state.dart';

class TrendingTvShowsBloc extends Bloc<UiEvent, UiState> {
  TrendingTvShowsBloc(this.trendingTvShowsUseCase)
    : super(TrendingTvShowsLoading()) {
    on<LoadTrendingTvShows>(_load);
  }

  final TrendingTvShowsUseCase trendingTvShowsUseCase;

  Future<void> _load(
    LoadTrendingTvShows event,
    Emitter<UiState> emit,
  ) async {
    try {
      if (state is! TrendingTvShowsLoaded) {
        emit(TrendingTvShowsLoading());
      }
      final trendingTvShows = await trendingTvShowsUseCase.getTrendingTvShows(
        'bc0abeeb117c70b4a31a9b439dd7e981',
        'us-US',
        event.selectedPeriod,
      );
      emit(
        TrendingTvShowsLoaded(
          trendingContent: trendingTvShows,
          currentWindow: event.selectedPeriod,
          isExpanded: true,
        ),
      );
    } catch (e, st) {
      emit(TrendingTvShowsLoadingFailure(exception: e));
      GetIt.I<Talker>().handle(e, st);
    } finally {
      event.completer?.complete();
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
