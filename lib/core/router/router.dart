import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

import '../../features/movies/domain/models/movie.dart';
import '../../features/screens.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: MainHomeRoute.page, initial: true),
    AutoRoute(page: MoviesRoute.page),
    AutoRoute(page: MovieDetailsRoute.page),
  ];
}
