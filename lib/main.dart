import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:tmdb_flutter_app/features/actors/domain/usecases/usecases.dart';
import 'package:tmdb_flutter_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:tmdb_flutter_app/features/home/domain/repositories/home_epository.dart';
import 'package:tmdb_flutter_app/features/tv_shows/data/repositories/tv_shows_repository_impl.dart';
import 'package:tmdb_flutter_app/tmdb_flutter_app.dart';

import 'core/connection/internet_connection_checker.dart';
import 'features/actors/data/repositories/actors_repository_impl.dart';
import 'features/actors/domain/repositories/actors_repository.dart';
import 'features/movies/data/repositories/movie_repository_impl.dart';
import 'features/movies/domain/repositories/movie_repository.dart';
import 'features/movies/domain/usecases/usecases.dart';
import 'features/tv_shows/domain/usecases/usecases.dart';
import 'features/tv_shows/domain/repositories/tv_shows_repository.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Enables debug paint to see view shapes
    debugPaintSizeEnabled = false;

    // Optional: Set 'true' to make zone mismatch fatal during dev/debug
    BindingBase.debugZoneErrorsAreFatal = false;


    final di = GetIt.I;
    final talker = TalkerFlutter.init();
    di.registerSingleton(talker);
    di<Talker>().debug('Talker initialized');

    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.themoviedb.org/3',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    dio.interceptors.addAll([
      ConnectionInterceptor(),
      TalkerDioLogger(
        settings: TalkerDioLoggerSettings(
          printRequestData: true,
          printResponseData: true,
        ),
      ),
    ]);

    Bloc.observer = TalkerBlocObserver(
      talker: talker,
      settings: TalkerBlocLoggerSettings(
        printStateFullData: true,
        printEventFullData: true,
      ),
    );

    di.registerLazySingleton<MovieRepository>(
      () => MovieRepositoryImpl(dio: dio),
    );

    di.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(dio: dio),
    );

    di.registerLazySingleton<TvShowsRepository>(
      () => TvShowsRepositoryImpl(dio: dio),
    );

    di.registerLazySingleton<ActorsRepository>(
      () => ActorsRepositoryImpl(dio: dio),
    );

    di.registerLazySingleton<TrendingMoviesUseCase>(
      () =>
          TrendingMoviesUseCaseImpl(repository: di.get<MovieRepository>()),
    );

    di.registerLazySingleton<NowPlayingMoviesUseCase>(
      () => NowPlayingMoviesUseCaseImpl(
        repository: di.get<MovieRepository>(),
      ),
    );

    di.registerLazySingleton<PopularMoviesUseCase>(
      () =>
          PopularMoviesUseCaseImpl(repository: di.get<MovieRepository>()),
    );

    di.registerLazySingleton<UpcomingMoviesUseCase>(
      () =>
          UpcomingMoviesUseCaseImpl(repository: di.get<MovieRepository>()),
    );

    di.registerLazySingleton<TopRatedMoviesUseCase>(
      () =>
          TopRatedMoviesUseCaseImpl(repository: di.get<MovieRepository>()),
    );

    di.registerLazySingleton<DiscoverContentUseCase>(
      () =>
          DiscoverContentUseCaseImpl(repository: di.get<HomeRepository>()),
    );

    di.registerLazySingleton<TopRatedTvShowsUseCase>(
      () => TopRatedTvShowsUseCaseImpl(
        repository: di.get<TvShowsRepository>(),
      ),
    );

    di.registerLazySingleton<PopularTvShowsUseCase>(
      () => PopularTvShowsUseCaseImpl(
        repository: di.get<TvShowsRepository>(),
      ),
    );

    di.registerLazySingleton<TrendingTvShowsUseCase>(
      () => TrendingTvShowsUseCaseImpl(
        repository: di.get<TvShowsRepository>(),
      ),
    );

    di.registerLazySingleton<AiringTodayTvShowsUseCase>(
      () => AiringTodayTvShowsUseCaseImpl(
        repository: di.get<TvShowsRepository>(),
      ),
    );

    di.registerLazySingleton<PopularActorsUseCase>(
      () => PopularActorsUseCaseImpl(
        repository: di.get<ActorsRepository>(),
      ),
    );

    FlutterError.onError = (details) =>
        di<Talker>().handle(details.exception, details.stack);

    WidgetsFlutterBinding.ensureInitialized();

    try {
      await dotenv.load(fileName: "tmdb_app_properties.env");
    } catch (e, stackTrace) {
      debugPrint("Failed to load .env file: $e");
      di<Talker>().handle(e, stackTrace);
    }

    runApp(
      MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: TmdbFlutterApp(),
      ),
    );
  }, (e, st) => GetIt.I<Talker>().handle(e, st));
}
