import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../common/common.dart';
import '../../domain/models/actors_list_result.dart';
import 'package:tmdb_flutter_app/features/actors/domain/usecases/usecases.dart';

part 'popular_actors_event.dart';

part 'popular_actors_state.dart';

class PopularActorsBloc extends Bloc<UiEvent, UiState> {
  PopularActorsBloc(this.popularActorsUseCase)
      : super(PopularActorsInitial()) {
    on<LoadPopularActors>(_load);
  }

  final PopularActorsUseCase popularActorsUseCase;

  // local pagination accumulator
  final List<ActorsListResults> _buffer = [];
  int _nextPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  Future<void> _load(LoadPopularActors event, Emitter<UiState> emit) async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      if (event.reset) {
        _buffer.clear();
        _nextPage = 1;
        _hasMore = true;
        emit(PopularActorsLoading());
      }

      if (!_hasMore) {
        emit(
          PopularActorsLoaded(
            popularActors: List.unmodifiable(_buffer),
            page: _nextPage - 1,
            hasMore: false,
          ),
        );
        return;
      }

      final result = await popularActorsUseCase.getPopularActors(
        _nextPage,
        'us-US',
      );

      _buffer.addAll(result.results ?? const []);
      final totalPages = result.totalPages ?? _nextPage; // fallback
      _hasMore = _nextPage < totalPages;
      _nextPage++;

      emit(
        PopularActorsLoaded(
          popularActors: List.unmodifiable(_buffer),
          page: _nextPage - 1,
          hasMore: _hasMore,
        ),
      );
    } catch (e) {
      emit(PopularActorsLoadingFailure(exception: e));
    } finally {
      _isLoading = false;
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
