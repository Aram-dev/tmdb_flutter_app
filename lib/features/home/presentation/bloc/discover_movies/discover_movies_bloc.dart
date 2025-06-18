import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:tmdb_flutter_app/features/movies/domain/usecases/usecases.dart';
import '../../../../common/common.dart';

part 'discover_movies_event.dart';

part 'discover_movies_state.dart';

class DiscoverContentBloc extends Bloc<MoviesEvent, MoviesState> {
  DiscoverContentBloc(this.discoverMoviesUseCase) : super(DiscoverMoviesInitial()) {
    on<LoadDiscoverContent>(_load);
    on<ToggleSection>(_onToggleSection);
  }

  final DiscoverContentUseCase discoverMoviesUseCase;

  Future<void> _load(LoadDiscoverContent event, Emitter<MoviesState> emit) async {
    try {
      if (state is! DiscoverContentLoaded) {
        emit(DiscoverContentLoading());
      }
      final discoverContent = await discoverMoviesUseCase.getDiscoverContent(
        page: 1,
        apiKey: 'bc0abeeb117c70b4a31a9b439dd7e981',
        language: 'us-US',
        category: event.category,
      );
      emit(
        DiscoverContentLoaded(discoverMovies: discoverContent, isExpanded: false),
      );
    } catch (e, st) {
      emit(DiscoverContentLoadingFailure(exception: e));
      GetIt.I<Talker>().handle(e, st);
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _onToggleSection(
    ToggleSection event,
    Emitter<MoviesState> emit,
  ) async {
    if (state is DiscoverContentLoaded) {
      final currentState = state as DiscoverContentLoaded;
      // Emit new state with toggled isExpanded (movies list remains same)
      emit(
        DiscoverContentLoaded(
          discoverMovies: currentState.discoverMovies,
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
