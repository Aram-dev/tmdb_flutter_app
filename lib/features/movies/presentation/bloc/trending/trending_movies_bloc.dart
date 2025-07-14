import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../../common/common.dart';

part 'trending_movies_event.dart';

part 'trending_movies_state.dart';

class TrendingMoviesBloc extends Bloc<UiEvent, UiState> {
  TrendingMoviesBloc(this.trendingMoviesUseCase)
    : super(TrendingMoviesLoading()) {
    on<LoadTrendingMovies>(_load);
  }

  final TrendingMoviesUseCase trendingMoviesUseCase;

  Future<void> _load(
    LoadTrendingMovies event,
    Emitter<UiState> emit,
  ) async {
    try {
      if (state is! TrendingMoviesLoaded) {
        emit(TrendingMoviesLoading());
      }
      final trendingMovies = await trendingMoviesUseCase.getTrendingMovies(
        'bc0abeeb117c70b4a31a9b439dd7e981',
        'us-US',
        event.selectedPeriod,
      );
      emit(
        TrendingMoviesLoaded(
          trendingMovies: trendingMovies,
          currentWindow: event.selectedPeriod,
          isExpanded: true,
        ),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        emit(ConnectionFailure(exception: e));
      } else {
        emit(TrendingMoviesLoadingFailure(exception: e));
      }
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
