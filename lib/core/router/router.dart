import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

import '../../features/actors/presentation/bloc/actor_details_bloc.dart';
import '../../features/movies/domain/models/movie.dart';
import '../../features/movies/presentation/bloc/movie_details/movie_details_bloc.dart';
import '../../features/screens.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: SignInRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(page: MainHomeRoute.page),
    AutoRoute(page: MoviesRoute.page),
    AutoRoute(page: MovieDetailsRoute.page),
    AutoRoute(page: ActorDetailsRoute.page),
  ];
}
