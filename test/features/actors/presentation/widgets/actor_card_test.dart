import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tmdb_flutter_app/core/router/router.gr.dart';
import 'package:tmdb_flutter_app/features/actors/domain/models/actors_list_result.dart';
import 'package:tmdb_flutter_app/features/actors/domain/models/actors_list_result_known_for.dart';
import 'package:tmdb_flutter_app/features/actors/presentation/widgets/actor_card.dart';

class _MockStackRouter extends Mock implements StackRouter {}

class _FakePageRouteInfo<T> extends Fake implements PageRouteInfo<T> {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakePageRouteInfo());
  });

  ActorsListResults _buildActor() {
    return ActorsListResults(
      adult: false,
      gender: 1,
      id: 1,
      knownForDepartment: 'Acting',
      name: 'Jane Smith',
      originalName: 'Jane Smith',
      popularity: 12.0,
      profilePath: '/profile.jpg',
      knownFor: const [
        ActorsListResultsKnownFor(
          adult: false,
          backdropPath: '/backdrop.jpg',
          id: 10,
          title: 'Movie A',
          originalLanguage: 'en',
          originalTitle: 'Movie A',
          overview: 'Overview',
          posterPath: '/poster.jpg',
          mediaType: 'movie',
          genreIds: [1, 2],
          popularity: 5.0,
          releaseDate: '2020-01-01',
          video: false,
          voteAverage: 7.5,
          voteCount: 200,
        ),
      ],
    );
  }

  testWidgets('taps navigate to actor details route', (tester) async {
    final router = _MockStackRouter();
    when(() => router.push(any())).thenAnswer((_) async => null);

    await tester.pumpWidget(
      MaterialApp(
        home: StackRouterScope(
          controller: router,
          stateHash: 0,
          child: Scaffold(
            body: ActorCard(actor: _buildActor()),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ActorCard));
    await tester.pumpAndSettle();

    verify(
      () => router.push(any(that: isA<ActorDetailsRoute>())),
    ).called(1);
  });
}
