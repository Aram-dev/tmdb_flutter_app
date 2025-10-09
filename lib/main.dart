import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:tmdb_flutter_app/tmdb_flutter_app.dart';

import 'di/locator.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Disable debug paint overlay (set to true to visualize layout bounds)
    debugPaintSizeEnabled = false;

    // Optional: Set 'true' to make zone mismatch fatal during dev/debug
    BindingBase.debugZoneErrorsAreFatal = false;


    await initLocator();
    final di = GetIt.I;

    Bloc.observer = TalkerBlocObserver(
      talker: di<Talker>(),
      settings: TalkerBlocLoggerSettings(
        printStateFullData: true,
        printEventFullData: true,
      ),
    );

    FlutterError.onError = (details) => di<Talker>().handle(details.exception, details.stack);

    WidgetsFlutterBinding.ensureInitialized();

    runApp(const TmdbFlutterApp());
  }, (e, st) => GetIt.I<Talker>().handle(e, st));
}
