import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../common/common.dart';
import '../../domain/models/actor_details.dart';
import '../../domain/usecases/usecases.dart';

part 'actor_details_event.dart';
part 'actor_details_state.dart';

class ActorDetailsBloc extends Bloc<ActorDetailsEvent, ActorDetailsState> {
  ActorDetailsBloc(this.actorDetailsUseCase)
      : super(ActorDetailsInitial()) {
    on<LoadActorDetails>(_onLoad);
  }

  final ActorDetailsUseCase actorDetailsUseCase;

  Future<void> _onLoad(
    LoadActorDetails event,
    Emitter<ActorDetailsState> emit,
  ) async {
    emit(ActorDetailsLoading());
    try {
      final details = await actorDetailsUseCase.getActorDetails(
        event.actorId,
        event.language ?? 'en-US',
      );
      emit(ActorDetailsLoaded(actorDetails: details));
    } catch (e) {
      emit(ActorDetailsFailure(exception: e));
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
