import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../common/common.dart';
import '../../domain/models/actor_details.dart';
import '../../domain/models/actors_list_result.dart';
import '../../domain/usecases/usecases.dart';

part 'actor_details_event.dart';
part 'actor_details_state.dart';

class ActorDetailsBloc extends Bloc<UiEvent, UiState> {
  ActorDetailsBloc({
    required this.actorDetailsUseCase,
    ActorsListResults? initialActor,
  }) : super(ActorDetailsInitial(initialActor: initialActor)) {
    on<FetchActorDetails>(_onFetch);
  }

  final ActorDetailsUseCase actorDetailsUseCase;
  final String _apiKey = dotenv.env['PERSONAL_TMDB_API_KEY'] ?? '';

  Future<void> _onFetch(
    FetchActorDetails event,
    Emitter<UiState> emit,
  ) async {
    final fallbackActor = event.initialActor ?? _resolveInitialActor();

    if (_apiKey.isEmpty) {
      emit(
        ActorDetailsFailure(
          exception: StateError('Missing TMDB API key'),
          initialActor: fallbackActor,
        ),
      );
      return;
    }

    emit(ActorDetailsLoading(initialActor: fallbackActor));

    try {
      final details = await actorDetailsUseCase.fetchActorDetails(
        actorId: event.actorId,
        apiKey: _apiKey,
        language: 'en-US',
      );
      emit(ActorDetailsLoaded(details: details));
    } catch (error) {
      emit(
        ActorDetailsFailure(
          exception: error,
          initialActor: fallbackActor,
        ),
      );
    }
  }

  ActorsListResults? _resolveInitialActor() {
    final current = state;
    if (current is ActorDetailsInitial) return current.initialActor;
    if (current is ActorDetailsLoading) return current.initialActor;
    if (current is ActorDetailsFailure) return current.initialActor;
    return null;
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
