// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    ActorDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<ActorDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ActorDetailsScreen(
          key: args.key,
          actorId: args.actorId,
          actorName: args.actorName,
          blocOverride: args.blocOverride,
        ),
      );
    },
    ActorsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ActorsScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    MainHomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainHomeScreen(),
      );
    },
    MovieDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<MovieDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MovieDetailsScreen(
          key: args.key,
          movie: args.movie,
          blocOverride: args.blocOverride,
        ),
      );
    },
    MoviesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MoviesScreen(),
      );
    },
    ProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileScreen(),
      );
    },
    RegisterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterScreen(),
      );
    },
    SearchRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SearchScreen(),
      );
    },
    SignInRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SignInScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
    TvShowsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TvShowsScreen(),
      );
    },
  };
}

/// generated route for
/// [ActorDetailsScreen]
class ActorDetailsRoute extends PageRouteInfo<ActorDetailsRouteArgs> {
  ActorDetailsRoute({
    Key? key,
    required int actorId,
    String? actorName,
    ActorDetailsBloc? blocOverride,
    List<PageRouteInfo>? children,
  }) : super(
          ActorDetailsRoute.name,
          args: ActorDetailsRouteArgs(
            key: key,
            actorId: actorId,
            actorName: actorName,
            blocOverride: blocOverride,
          ),
          initialChildren: children,
        );

  static const String name = 'ActorDetailsRoute';

  static const PageInfo<ActorDetailsRouteArgs> page =
      PageInfo<ActorDetailsRouteArgs>(name);
}

class ActorDetailsRouteArgs {
  const ActorDetailsRouteArgs({
    this.key,
    required this.actorId,
    this.actorName,
    this.blocOverride,
  });

  final Key? key;

  final int actorId;

  final String? actorName;

  final ActorDetailsBloc? blocOverride;

  @override
  String toString() {
    return 'ActorDetailsRouteArgs{key: $key, actorId: $actorId, actorName: $actorName, blocOverride: $blocOverride}';
  }
}

/// generated route for
/// [ActorsScreen]
class ActorsRoute extends PageRouteInfo<void> {
  const ActorsRoute({List<PageRouteInfo>? children})
      : super(
          ActorsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ActorsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainHomeScreen]
class MainHomeRoute extends PageRouteInfo<void> {
  const MainHomeRoute({List<PageRouteInfo>? children})
      : super(
          MainHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainHomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MovieDetailsScreen]
class MovieDetailsRoute extends PageRouteInfo<MovieDetailsRouteArgs> {
  MovieDetailsRoute({
    Key? key,
    required Movie movie,
    MovieDetailsBloc? blocOverride,
    List<PageRouteInfo>? children,
  }) : super(
          MovieDetailsRoute.name,
          args: MovieDetailsRouteArgs(
            key: key,
            movie: movie,
            blocOverride: blocOverride,
          ),
          initialChildren: children,
        );

  static const String name = 'MovieDetailsRoute';

  static const PageInfo<MovieDetailsRouteArgs> page =
      PageInfo<MovieDetailsRouteArgs>(name);
}

class MovieDetailsRouteArgs {
  const MovieDetailsRouteArgs({
    this.key,
    required this.movie,
    this.blocOverride,
  });

  final Key? key;

  final Movie movie;

  final MovieDetailsBloc? blocOverride;

  @override
  String toString() {
    return 'MovieDetailsRouteArgs{key: $key, movie: $movie, blocOverride: $blocOverride}';
  }
}

/// generated route for
/// [MoviesScreen]
class MoviesRoute extends PageRouteInfo<void> {
  const MoviesRoute({List<PageRouteInfo>? children})
      : super(
          MoviesRoute.name,
          initialChildren: children,
        );

  static const String name = 'MoviesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterScreen]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SearchScreen]
class SearchRoute extends PageRouteInfo<void> {
  const SearchRoute({List<PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SignInScreen]
class SignInRoute extends PageRouteInfo<void> {
  const SignInRoute({List<PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TvShowsScreen]
class TvShowsRoute extends PageRouteInfo<void> {
  const TvShowsRoute({List<PageRouteInfo>? children})
      : super(
          TvShowsRoute.name,
          initialChildren: children,
        );

  static const String name = 'TvShowsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
