import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:tmdb_flutter_app/features/movies/data/repositories/now_playing_movies_repository_impl.dart';
import 'package:tmdb_flutter_app/features/movies/domain/repositories/movies_now_playing.dart';
import 'package:tmdb_flutter_app/features/movies/domain/usecases/now_playing_movies_use_case.dart';
import 'package:tmdb_flutter_app/features/movies/domain/usecases/now_playing_movies_use_case_impl.dart';
import 'package:tmdb_flutter_app/tmdb_flutter_app.dart';

import 'features/main_home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final talker = TalkerFlutter.init();
  GetIt.I.registerSingleton(talker);
  GetIt.I<Talker>().debug('Talker initialized');

  final dio = Dio();
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

  GetIt.I.registerLazySingleton<NowPlayingMoviesRepository>(
    () => NowPlayingMoviesRepositoryImpl(dio: dio),
  );

  GetIt.I.registerLazySingleton<NowPlayingMoviesUseCase>(
    () => NowPlayingMoviesUseCaseImpl(
      repository: GetIt.I.get<NowPlayingMoviesRepository>(),
    ),
  );

  FlutterError.onError = (details) =>
      GetIt.I<Talker>().handle(details.exception, details.stack);

  runZonedGuarded(() => runApp(const TmdbFlutterApp()),
          (e, st) => GetIt.I<Talker>().handle(e, st));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainHomeScreen(),
    );
  }
}
