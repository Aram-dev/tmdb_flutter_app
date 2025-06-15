import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../domain/usecases/usecases.dart';
import '../base/base.dart';

part 'trending_movies_event.dart';

part 'trending_movies_state.dart';

class TrendingMoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  TrendingMoviesBloc(this.trendingMoviesUseCase)
    : super(TrendingMoviesInitial()) {
    on<LoadTrendingMovies>(_load);
  }

  final TrendingMoviesUseCase trendingMoviesUseCase;

  Future<void> _load(
    LoadTrendingMovies event,
    Emitter<MoviesState> emit,
  ) async {
    try {
      if (state is! TrendingMoviesLoaded) {
        emit(TrendingMoviesLoading());
      }
      final trendingMovies = await trendingMoviesUseCase.getTrendingMovies(
        'bc0abeeb117c70b4a31a9b439dd7e981',
        'us-US',
        event.selectedWindow,
      );
      emit(
        TrendingMoviesLoaded(
          trendingMovies: trendingMovies,
          currentWindow: event.selectedWindow,
          isExpanded: true,
        ),
      );
    } catch (e, st) {
      emit(TrendingMoviesLoadingFailure(exception: e));
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
