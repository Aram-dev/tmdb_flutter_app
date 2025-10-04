import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tmdb_flutter_app/features/actors/domain/models/actor_details.dart';
import 'package:tmdb_flutter_app/features/actors/domain/usecases/usecases.dart';
import 'package:tmdb_flutter_app/features/actors/presentation/bloc/actor_details_bloc.dart';

class _MockActorDetailsUseCase extends Mock implements ActorDetailsUseCase {}

void main() {
  late _MockActorDetailsUseCase useCase;
  late ActorDetails actorDetails;

  setUp(() {
    useCase = _MockActorDetailsUseCase();
    actorDetails = const ActorDetails(
      id: 1,
      name: 'John Doe',
      biography: 'An actor biography',
      profilePath: '/profile.jpg',
      knownForDepartment: 'Acting',
    );
  });

  group('ActorDetailsBloc', () {
    blocTest<ActorDetailsBloc, ActorDetailsState>(
      'emits [loading, loaded] when use case succeeds',
      build: () {
        when(() => useCase.getActorDetails(any(), any()))
            .thenAnswer((_) async => actorDetails);
        return ActorDetailsBloc(useCase);
      },
      act: (bloc) => bloc.add(LoadActorDetails(actorId: actorDetails.id)),
      expect: () => [
        ActorDetailsLoading(),
        ActorDetailsLoaded(actorDetails: actorDetails),
      ],
      verify: (_) {
        verify(() => useCase.getActorDetails(actorDetails.id, any()))
            .called(1);
      },
    );

    blocTest<ActorDetailsBloc, ActorDetailsState>(
      'emits [loading, failure] when use case throws',
      build: () {
        when(() => useCase.getActorDetails(any(), any()))
            .thenThrow(Exception('boom'));
        return ActorDetailsBloc(useCase);
      },
      act: (bloc) => bloc.add(LoadActorDetails(actorId: actorDetails.id)),
      expect: () => [
        ActorDetailsLoading(),
        isA<ActorDetailsFailure>(),
      ],
      verify: (_) {
        verify(() => useCase.getActorDetails(actorDetails.id, any()))
            .called(1);
      },
    );
  });
}
