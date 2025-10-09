import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import '../core/connection/internet_connection_checker.dart';
import '../features/auth/data/datasources/auth_local_data_source.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/interceptors/auth_interceptor.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/actors/data/repositories/actors_repository_impl.dart';
import '../features/actors/domain/repositories/actors_repository.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../features/movies/data/repositories/movie_repository_impl.dart';
import '../features/movies/domain/repositories/movie_repository.dart';
import '../features/movies/domain/usecases/usecases.dart';
import '../features/actors/domain/usecases/usecases.dart';
import '../features/tv_shows/data/repositories/tv_shows_repository_impl.dart';
import '../features/tv_shows/domain/repositories/tv_shows_repository.dart';
import '../features/tv_shows/domain/usecases/usecases.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final sl = GetIt.instance;

Future<void> initLocator() async {
  final talker = TalkerFlutter.init();
  if (sl.isRegistered<Talker>()) {
    sl.unregister<Talker>();
  }
  sl.registerLazySingleton<Talker>(() => talker);

  // Build and register Dio
  final dio = await _buildDio();
  if (sl.isRegistered<Dio>()) {
    sl.unregister<Dio>();
  }
  sl.registerLazySingleton<Dio>(() => dio);

  // Shared services
  sl.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());

  // Data sources & repositories
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSource(storage: sl.get<FlutterSecureStorage>()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(dio: sl.get<Dio>()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        localDataSource: sl.get<AuthLocalDataSource>(),
        remoteDataSource: sl.get<AuthRemoteDataSource>(),
      ));

  sl.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(dio: sl.get<Dio>()));
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(dio: sl.get<Dio>()));
  sl.registerLazySingleton<TvShowsRepository>(() => TvShowsRepositoryImpl(dio: sl.get<Dio>()));
  sl.registerLazySingleton<ActorsRepository>(() => ActorsRepositoryImpl(dio: sl.get<Dio>()));

  // Use cases (movies)
  sl.registerLazySingleton<TrendingMoviesUseCase>(() => TrendingMoviesUseCaseImpl(repository: sl.get<MovieRepository>()));
  sl.registerLazySingleton<NowPlayingMoviesUseCase>(() => NowPlayingMoviesUseCaseImpl(repository: sl.get<MovieRepository>()));
  sl.registerLazySingleton<PopularMoviesUseCase>(() => PopularMoviesUseCaseImpl(repository: sl.get<MovieRepository>()));
  sl.registerLazySingleton<UpcomingMoviesUseCase>(() => UpcomingMoviesUseCaseImpl(repository: sl.get<MovieRepository>()));
  sl.registerLazySingleton<TopRatedMoviesUseCase>(() => TopRatedMoviesUseCaseImpl(repository: sl.get<MovieRepository>()));
  sl.registerLazySingleton<MovieDetailsUseCase>(() => MovieDetailsUseCaseImpl(repository: sl.get<MovieRepository>()));
  sl.registerLazySingleton<MovieCreditsUseCase>(() => MovieCreditsUseCaseImpl(repository: sl.get<MovieRepository>()));
  sl.registerLazySingleton<MovieReviewsUseCase>(() => MovieReviewsUseCaseImpl(repository: sl.get<MovieRepository>()));
  sl.registerLazySingleton<MovieRecommendationsUseCase>(() => MovieRecommendationsUseCaseImpl(repository: sl.get<MovieRepository>()));
  sl.registerLazySingleton<MovieWatchProvidersUseCase>(() => MovieWatchProvidersUseCaseImpl(repository: sl.get<MovieRepository>()));

  // Use cases (home)
  sl.registerLazySingleton<DiscoverContentUseCase>(() => DiscoverContentUseCaseImpl(repository: sl.get<HomeRepository>()));

  // Use cases (tv shows)
  sl.registerLazySingleton<TopRatedTvShowsUseCase>(() => TopRatedTvShowsUseCaseImpl(repository: sl.get<TvShowsRepository>()));
  sl.registerLazySingleton<PopularTvShowsUseCase>(() => PopularTvShowsUseCaseImpl(repository: sl.get<TvShowsRepository>()));
  sl.registerLazySingleton<TrendingTvShowsUseCase>(() => TrendingTvShowsUseCaseImpl(repository: sl.get<TvShowsRepository>()));
  sl.registerLazySingleton<AiringTodayTvShowsUseCase>(() => AiringTodayTvShowsUseCaseImpl(repository: sl.get<TvShowsRepository>()));

  // Use cases (actors)
  sl.registerLazySingleton<PopularActorsUseCase>(() => PopularActorsUseCaseImpl(repository: sl.get<ActorsRepository>()));
  sl.registerLazySingleton<ActorDetailsUseCase>(() => ActorDetailsUseCaseImpl(repository: sl.get<ActorsRepository>()));
}

Future<Dio> _buildDio() async {
  final baseUrl = const String.fromEnvironment('TMDB_BASE_URL', defaultValue: 'https://api.themoviedb.org/3');

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  // HTTP/2 + keepAlive
  dio.httpClientAdapter = Http2Adapter(
    ConnectionManager(idleTimeout: const Duration(seconds: 30)),
  );

  // Cache store selection
  CacheStore store;
  if (kIsWeb) {
    store = MemCacheStore();
  } else {
    final tmp = await getTemporaryDirectory();
    store = HiveCacheStore(tmp.path, hiveBoxName: 'dio_cache');
  }

  final cacheOptions = CacheOptions(
    store: store,
    policy: CachePolicy.request,
    hitCacheOnErrorExcept: const [401, 403],
    maxStale: const Duration(days: 7),
    priority: CachePriority.high,
  );

  if (sl.isRegistered<CacheOptions>()) {
    sl.unregister<CacheOptions>();
  }
  sl.registerSingleton<CacheOptions>(cacheOptions);

  final cacheInterceptor = DioCacheInterceptor(options: cacheOptions);

  final authInterceptor = AuthInterceptor(
    dio: dio,
    authRepositoryProvider: () => sl<AuthRepository>(),
  );

  dio.interceptors.addAll([
    cacheInterceptor,
    ConnectionInterceptor(),
    TalkerDioLogger(
      talker: sl<Talker>(),
      settings: TalkerDioLoggerSettings(
        printRequestData: true,
        printResponseData: !kReleaseMode, // avoid logging bodies in release
      ),
    ),
    authInterceptor,
    RetryInterceptor(
      dio: dio,
      logPrint: debugPrint,
      retries: 3,
      retryDelays: const [
        Duration(milliseconds: 250),
        Duration(milliseconds: 500),
        Duration(seconds: 1),
      ],
    ),
  ]);

  assert(() {
    dio.interceptors.add(LogInterceptor(requestBody: false, responseBody: false));
    return true;
  }());

  return dio;
}
