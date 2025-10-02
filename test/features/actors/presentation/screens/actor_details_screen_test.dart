import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tmdb_flutter_app/features/actors/domain/models/actor_details.dart';
import 'package:tmdb_flutter_app/features/actors/presentation/bloc/actor_details_bloc.dart';
import 'package:tmdb_flutter_app/features/actors/presentation/screens/actor_details_screen.dart';

class _MockActorDetailsBloc
    extends MockBloc<ActorDetailsEvent, ActorDetailsState>
    implements ActorDetailsBloc {}

class _FakeActorDetailsEvent extends Fake implements ActorDetailsEvent {}

class _FakeActorDetailsState extends Fake implements ActorDetailsState {}

void main() {
  late ActorDetails actorDetails;

  setUpAll(() {
    registerFallbackValue(_FakeActorDetailsEvent());
    registerFallbackValue(_FakeActorDetailsState());
  });

  setUp(() {
    actorDetails = const ActorDetails(
      id: 1,
      name: 'John Doe',
      biography: 'A biography',
      profilePath: null,
    );
  });

  Widget _wrapWithMaterial(Widget child) {
    return MaterialApp(home: child);
  }

  testWidgets('renders loading state', (tester) async {
    final bloc = _MockActorDetailsBloc();
    when(() => bloc.state).thenReturn(const ActorDetailsLoading());
    whenListen(
      bloc,
      const Stream<ActorDetailsState>.empty(),
      initialState: const ActorDetailsLoading(),
    );

    await tester.pumpWidget(
      _wrapWithMaterial(
        ActorDetailsScreen(
          actorId: actorDetails.id,
          blocOverride: bloc,
        ),
      ),
    );

    expect(find.byKey(const Key('actorDetailsLoading')), findsOneWidget);
  });

  testWidgets('renders success state with details', (tester) async {
    final bloc = _MockActorDetailsBloc();
    when(() => bloc.state)
        .thenReturn(ActorDetailsLoaded(actorDetails: actorDetails));
    whenListen(
      bloc,
      Stream<ActorDetailsState>.fromIterable([
        ActorDetailsLoaded(actorDetails: actorDetails),
      ]),
      initialState: ActorDetailsLoaded(actorDetails: actorDetails),
    );

    await tester.pumpWidget(
      _wrapWithMaterial(
        ActorDetailsScreen(
          actorId: actorDetails.id,
          actorName: actorDetails.name,
          blocOverride: bloc,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('actorDetailsName')), findsOneWidget);
    expect(find.text(actorDetails.name!), findsOneWidget);
    expect(find.byKey(const Key('actorDetailsBiography')), findsOneWidget);
  });

  testWidgets('renders error state and taps retry', (tester) async {
    final bloc = _MockActorDetailsBloc();
    when(() => bloc.state).thenReturn(
      ActorDetailsFailure(exception: Exception('error')),
    );
    whenListen(
      bloc,
      Stream<ActorDetailsState>.fromIterable([
        ActorDetailsFailure(exception: Exception('error')),
      ]),
      initialState: ActorDetailsFailure(exception: Exception('error')),
    );

    await tester.pumpWidget(
      _wrapWithMaterial(
        ActorDetailsScreen(
          actorId: actorDetails.id,
          blocOverride: bloc,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('actorDetailsRetryButton')));
    await tester.pump();

    verify(() => bloc.add(any(that: isA<LoadActorDetails>()))).called(1);
  });
}
