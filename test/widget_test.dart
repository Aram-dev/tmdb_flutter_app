import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:tmdb_flutter_app/features/home/domain/usecases/discover_movies/discover_movies_use_case.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movie.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movies_dates_entity.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movies_entity.dart';
import 'package:tmdb_flutter_app/features/movies/domain/usecases/trending/trending_movies_use_case.dart';
import 'package:tmdb_flutter_app/tmdb_flutter_app.dart';

class _FakeDiscoverContentUseCase extends DiscoverContentUseCase {
  _FakeDiscoverContentUseCase(this._entity);

  final MovieTvShowEntity _entity;

  @override
  Future<MovieTvShowEntity> getDiscoverContent({
    required int page,
    required String apiKey,
    required String language,
    required String category,
    String? region,
    bool? includeAdult,
    bool? includeVideo,
    String? certification,
    int? primaryReleaseYear,
    String? certificationGte,
    String? certificationLte,
    String? certificationCountry,
  }) async {
    return _entity;
  }
}

class _FakeTrendingMoviesUseCase extends TrendingMoviesUseCase {
  _FakeTrendingMoviesUseCase(this._entity);

  final MovieTvShowEntity _entity;

  @override
  Future<MovieTvShowEntity> getTrendingMovies(
    String apiKey,
    String language,
    String timeWindow,
  ) async {
    return _entity;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final getIt = GetIt.instance;

  const testMovie = Movie(
    adult: false,
    backdropPath: null,
    genreIds: <int>[28, 12],
    id: 123,
    originalLanguage: 'en',
    originalTitle: 'Sample Movie',
    overview: 'An exciting adventure.',
    popularity: 9.9,
    posterPath: null,
    releaseDate: '2024-01-01',
    title: 'Sample Movie',
    video: false,
    voteAverage: 8.5,
    voteCount: 1000,
  );

  const fakeEntity = MovieTvShowEntity(
    dates: MoviesDates(maximum: '2024-01-02', minimum: '2023-12-31'),
    page: 1,
    results: <Movie>[testMovie],
    totalPages: 1,
    totalResults: 1,
  );

  setUp(() async {
    await getIt.reset();
    dotenv.testLoad(fileInput: 'PERSONAL_TMDB_API_KEY=dummy');

    getIt.registerSingleton<Talker>(TalkerFlutter.init());
    getIt.registerLazySingleton<DiscoverContentUseCase>(
      () => _FakeDiscoverContentUseCase(fakeEntity),
    );
    getIt.registerLazySingleton<TrendingMoviesUseCase>(
      () => _FakeTrendingMoviesUseCase(fakeEntity),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('renders home content with discover and trending sections',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TmdbFlutterApp());

    await tester.pumpAndSettle();

    expect(find.text('Discover'), findsOneWidget);
    expect(find.text('Trending'), findsOneWidget);
    expect(find.text('Sample Movie'), findsWidgets);
  });
}
