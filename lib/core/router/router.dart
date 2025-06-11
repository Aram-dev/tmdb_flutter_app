import 'package:auto_route/auto_route.dart';
import 'package:tmdb_flutter_app/features/main_home_screen.dart';
import 'package:tmdb_flutter_app/features/home/presentation/screens/home_screen.dart';
import 'package:tmdb_flutter_app/features/movies/presentation/screens/movies_screen.dart';
import 'package:tmdb_flutter_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:tmdb_flutter_app/features/actors/presentation/screens/actors_screen.dart';
import 'package:tmdb_flutter_app/features/search/presentation/screens/movies_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: MainHomeRoute.page, initial: true),
    AutoRoute(page: MoviesRoute.page),
  ];
}

// final routes = {
// '/': (context) => const CryptoListScreen(),
// '/coin': (context) => const CryptoCoinScreen(),
// };