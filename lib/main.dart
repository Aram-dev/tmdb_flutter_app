import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:tmdb_flutter_app/tmdb_flutter_app.dart';

import 'features/movies/data/repositories/movie_repository_impl.dart';
import 'features/movies/domain/repositories/movie_repository.dart';
import 'features/movies/domain/usecases/usecases.dart';

void main() {
  // Enables debug paint to see view shapes
  debugPaintSizeEnabled = false;

  // Optional: Set 'true' to make zone mismatch fatal during dev/debug
  BindingBase.debugZoneErrorsAreFatal = false;

  final talker = TalkerFlutter.init();
  GetIt.I.registerSingleton(talker);
  GetIt.I<Talker>().debug('Talker initialized');

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  dio.interceptors.add(
    TalkerDioLogger(
      settings: TalkerDioLoggerSettings(
        printRequestData: true,
        printResponseData: true,
      ),
    ),
  );

  Bloc.observer = TalkerBlocObserver(
    talker: talker,
    settings: TalkerBlocLoggerSettings(
      printStateFullData: true,
      printEventFullData: true,
    ),
  );

  GetIt.I.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(dio: dio),
  );

  GetIt.I.registerLazySingleton<TrendingMoviesUseCase>(
    () => TrendingMoviesUseCaseImpl(repository: GetIt.I.get<MovieRepository>()),
  );

  GetIt.I.registerLazySingleton<NowPlayingMoviesUseCase>(
    () =>
        NowPlayingMoviesUseCaseImpl(repository: GetIt.I.get<MovieRepository>()),
  );

  GetIt.I.registerLazySingleton<PopularMoviesUseCase>(
    () => PopularMoviesUseCaseImpl(repository: GetIt.I.get<MovieRepository>()),
  );

  GetIt.I.registerLazySingleton<UpcomingMoviesUseCase>(
    () => UpcomingMoviesUseCaseImpl(repository: GetIt.I.get<MovieRepository>()),
  );

  GetIt.I.registerLazySingleton<TopRatedMoviesUseCase>(
    () => TopRatedMoviesUseCaseImpl(repository: GetIt.I.get<MovieRepository>()),
  );

  FlutterError.onError = (details) =>
      GetIt.I<Talker>().handle(details.exception, details.stack);

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(
      MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: TmdbFlutterApp(),
      ));
  }, (e, st) => GetIt.I<Talker>().handle(e, st));
}
