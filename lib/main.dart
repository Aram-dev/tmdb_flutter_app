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
import 'package:tmdb_flutter_app/features/actors/domain/usecases/usecases.dart';
import 'package:tmdb_flutter_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:tmdb_flutter_app/features/home/domain/repositories/home_repository.dart';
import 'package:tmdb_flutter_app/features/tv_shows/data/repositories/tv_shows_repository_impl.dart';
import 'package:tmdb_flutter_app/tmdb_flutter_app.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/connection/internet_connection_checker.dart';
import 'features/actors/data/repositories/actors_repository_impl.dart';
import 'features/actors/domain/repositories/actors_repository.dart';
import 'features/movies/data/repositories/movie_repository_impl.dart';
import 'features/movies/domain/repositories/movie_repository.dart';
import 'features/movies/domain/usecases/usecases.dart';
import 'features/tv_shows/domain/usecases/usecases.dart';
import 'features/tv_shows/domain/repositories/tv_shows_repository.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';

import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Disable debug paint overlay (set to true to visualize layout bounds)
    debugPaintSizeEnabled = false;

    // Optional: Set 'true' to make zone mismatch fatal during dev/debug
    BindingBase.debugZoneErrorsAreFatal = false;


    final di = GetIt.I;
    final talker = TalkerFlutter.init();
    di.registerSingleton(talker);
    di<Talker>().debug('Talker initialized');

    final dio = await buildDio();

    Bloc.observer = TalkerBlocObserver(
      talker: talker,
      settings: TalkerBlocLoggerSettings(
        printStateFullData: true,
        printEventFullData: true,
      ),
    );

    di.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    );

    di.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSource(storage: di.get<FlutterSecureStorage>()),
    );

    di.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(dio: dio),
    );

    di.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        localDataSource: di.get<AuthLocalDataSource>(),
        remoteDataSource: di.get<AuthRemoteDataSource>(),
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

    di.registerLazySingleton<ActorDetailsUseCase>(
      () => ActorDetailsUseCaseImpl(
        repository: di.get<ActorsRepository>(),
      ),
    );

    FlutterError.onError = (details) =>
        di<Talker>().handle(details.exception, details.stack);

    WidgetsFlutterBinding.ensureInitialized();

    runApp(const TmdbFlutterApp());
  }, (e, st) => GetIt.I<Talker>().handle(e, st));
}

Future<Dio> buildDio() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    // headers: {'Accept-Encoding': 'gzip'}, // compression
  ));

  // HTTP/2 + keepAlive connection pooling
  dio.httpClientAdapter = Http2Adapter(
    ConnectionManager(idleTimeout: const Duration(seconds: 30)),
  );

  // Choose cache store: Hive on mobile/desktop, in-memory on web
  CacheStore store;
  if (kIsWeb) {
    store = MemCacheStore();
  } else {
    final tmp = await getTemporaryDirectory(); // e.g., /data/user/0/<app>/cache
    // You must pass a DIRECTORY PATH here, not just a name.
    store = HiveCacheStore(tmp.path, hiveBoxName: 'dio_cache');
  }

  // Disk cache (stale-while-revalidate flavor below in repo)
  final cacheOptions = CacheOptions(
    store: store,
    policy: CachePolicy.request, // use cache rules from repo
    hitCacheOnErrorExcept: [401, 403],
    maxStale: const Duration(days: 7),
    priority: CachePriority.high,
  );
  final di = GetIt.I;
  if (di.isRegistered<CacheOptions>()) {
    di.unregister<CacheOptions>();
  }
  di.registerSingleton<CacheOptions>(cacheOptions);
  final cacheInterceptor = DioCacheInterceptor(options: cacheOptions);

  dio.interceptors.addAll([
    cacheInterceptor,
    ConnectionInterceptor(),
    TalkerDioLogger(
      settings: TalkerDioLoggerSettings(
        printRequestData: true,
        printResponseData: true,
      ),
    ),
    // Retries with exponential backoff (no retry on 4xx)
    RetryInterceptor(
      dio: dio,
      logPrint: debugPrint,
      retries: 3,
      retryDelays: const [
        Duration(milliseconds: 250),
        Duration(milliseconds: 500),
        Duration(seconds: 1),
      ],
    )
  ]);

  // Only log in debug
  assert(() {
    dio.interceptors.add(LogInterceptor(requestBody: false, responseBody: false));
    return true;
  }());

  return dio;
}
