import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:tmdb_flutter_app/theme/theme.dart';

import 'core/router/router.dart';

class TmdbFlutterApp extends StatefulWidget {
  const TmdbFlutterApp({super.key});

  @override
  State<TmdbFlutterApp> createState() => _TmdbFlutterAppState();
}

class _TmdbFlutterAppState extends State<TmdbFlutterApp> {

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return MaterialApp.router(
      title: 'TmdbFlutterApp',
      theme: darkTheme,
      localizationsDelegates: const [
        // S.delegate,
        // GlobalMaterialLocalizations.delegate,
        // GlobalWidgetsLocalizations.delegate,
        // GlobalCupertinoLocalizations.delegate,
      ],
      // supportedLocales: S.delegate.supportedLocales,
      routerConfig: appRouter.config(
        navigatorObservers: () => [
          TalkerRouteObserver(GetIt.I<Talker>()),
        ],
      ),
    );
  }
}