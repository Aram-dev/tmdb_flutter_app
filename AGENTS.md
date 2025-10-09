# AGENTS.md — Rules & Playbook for `tmdb_flutter_app`

This file defines how Codex should build, test, structure, and review changes for this Flutter app.

## Overview
- Flutter app for TMDB.
- State mgmt: **BLoC** (`flutter_bloc`)
- DI: **GetIt**
- Networking: **Dio** + **dio_smart_retry**
- Logging: **talker_flutter** (+ `talker_dio_logger`)
- Navigation: **auto_route**
- Models & equality: **equatable**
- Persistence: **hive** (+ **path_provider**)

## Folder layout (must follow)

## Toolchain
- Flutter: stable channel (use FVM if available)
- Dart: >= 3.x
- Android minSdk 21+, iOS 13+
- Do **not** commit secrets. Use `--dart-define` or `.env` (ignored).

## Commands Codex must use
- Format (check): `dart format --output=none --set-exit-if-changed .`
- Analyze: `flutter analyze`
- Generate code (routes, etc.): `dart run build_runner build --delete-conflicting-outputs`
- Tests (unit & widget): `flutter test --coverage`
- Build debug (Android): `flutter build apk --debug`
- Optional l10n: `flutter gen-l10n`

**PR gate:** format + analyze + tests must pass; coverage target ≥ **80%**.

## Architecture rules
- **Clean layers**:
    - `domain` is pure Dart (no Flutter/Dio/Hive).
    - `data` owns Dio/Hive, mapping, and implements domain repos.
    - `presentation` depends on `domain` and `flutter_bloc`; no direct Dio/Hive calls.
- **Use cases** return `Either<Failure, T>` or a `Result<T>` type in `core`.
- **BLoC**:
    - One event = one intention; states are immutable (**equatable**).
    - No I/O in widgets; trigger via BLoC/use cases.
- **Navigation (auto_route)**:
    - Declare all routes in `routes/app_router.dart` with `@AutoRouter`.
    - Use typed args; avoid string routes.
- **DI (GetIt)**:
    - Register factories for blocs; lazy singletons for repos/clients.
    - No global singletons outside GetIt.
- **Networking (Dio)**:
    - Single `Dio` from DI with: `baseUrl`, timeouts, default headers.
    - Interceptors: `TalkerDioLogger`, `RetryInterceptor` (dio_smart_retry).
    - Mask secrets in logs; don’t log full response bodies in release.
- **Caching (Hive)**:
    - Box names are constants in `core/constants.dart`.
    - Cache only in repositories; never in presentation.
- **Errors**:
    - Map transport & parsing errors → typed `Failure` values.
    - Don’t throw raw `DioException` across layers.

## Code style & lint
- Follow `analysis_options.yaml` (Flutter lints + stricter rules).
- No `print`; use `talker` (debug) via a logging facade in `core`.
- Naming:
    - BLoCs: `MoviesBloc`; states end with `State`, events with `Event`.
    - Use cases: `GetPopularMoviesUseCase`.
    - Repos: `MoviesRepository` (abstract), `MoviesRepositoryImpl`.
    - Datasources: `MoviesRemoteDataSource`, `MoviesLocalDataSource`.
- Widgets:
    - Prefer small, composable, `const` constructors where possible.
    - Keep `build()` cheap.

## Testing policy
- **Unit**: mappers, use cases, repositories.
- **Widget**: pages, navigation, bloc→UI state rendering.
- **Bloc**: use `bloc_test` for event→state flows.
- **Network**: mock via Dio adapters/interceptors.
- Add golden tests for key screens when feasible.
- Coverage goal: **≥ 80%** (CI fails if below).

## Env & flavors
- Required defines:
    - `--dart-define=TMDB_BASE_URL=https://api.themoviedb.org/3`
    - `--dart-define=TMDB_API_KEY=***`
- Consider flavors: `dev`, `staging`, `prod` (separate ids, icons, endpoints).

## Pull request etiquette
- Small, focused diffs (< ~400 LOC).
- Include tests for new logic.
- Screenshots for UI changes (light/dark).
- Update `CHANGELOG.md` for user-visible changes.
- If routes/screens change, update `routes/` diagram or README snippet.

## What to do when unsure
1. Add/adjust a failing test demonstrating the uncertainty.
2. Propose up to two alternatives with pros/cons in the PR.
3. Don’t add new packages without justification.

## Example glue code (reference)

**GetIt locator (`lib/di/locator.dart`)**
```dart
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

final sl = GetIt.instance;

Future<void> initLocator() async {
  final talker = TalkerFlutter.init();
  sl.registerLazySingleton<Talker>(() => talker);

  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      baseUrl: const String.fromEnvironment('TMDB_BASE_URL'),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ));

    dio.interceptors.addAll([
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printRequestData: true,
          printResponseData: false,
        ),
      ),
      RetryInterceptor(
        dio: dio,
        retries: 3,
        retryDelays: const [
          Duration(milliseconds: 300),
          Duration(seconds: 1),
          Duration(seconds: 2),
        ],
        retryEvaluator: (e, _) =>
            e.type != DioExceptionType.cancel && e.response?.statusCode != 401,
      ),
    ]);
    return dio;
  });

  // Register datasources, repos, use cases, blocs here.
}
