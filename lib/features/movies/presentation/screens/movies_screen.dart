import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tmdb_flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:tmdb_flutter_app/features/movies/presentation/bloc/top_rated/top_rated_movies_bloc.dart';

import '../../../../core/connection/no_internet_dialog.dart';
import '../../domain/usecases/usecases.dart';

import '../../presentation/bloc/bloc.dart';
import '../../../common/common.dart';
import '../widgets/movies_screen_content.dart';

@RoutePage()
class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    final authRepository = GetIt.I<AuthRepository>();
    return MultiBlocProvider(
      providers: [
        BlocProvider<TrendingMoviesBloc>(
          create: (context) =>
              TrendingMoviesBloc(
                GetIt.I<TrendingMoviesUseCase>(),
                authRepository,
              )..add(
                LoadTrendingMovies(
                  selectedPeriod: 'day',
                  contentTypeId: 'movie',
                ),
              ),
        ),
        BlocProvider<PopularMoviesBloc>(
          create: (context) =>
              PopularMoviesBloc(
                GetIt.I<PopularMoviesUseCase>(),
                authRepository,
              )..add(LoadPopularMovies()),
        ),
        BlocProvider<NowPlayingMoviesBloc>(
          create: (context) =>
              NowPlayingMoviesBloc(
                GetIt.I<NowPlayingMoviesUseCase>(),
                authRepository,
              )..add(LoadNowPlayingMovies()),
        ),
        BlocProvider<UpcomingMoviesBloc>(
          create: (context) =>
              UpcomingMoviesBloc(
                GetIt.I<UpcomingMoviesUseCase>(),
                authRepository,
              )..add(LoadUpcomingMovies()),
        ),
        BlocProvider<TopRatedMoviesBloc>(
          create: (context) =>
              TopRatedMoviesBloc(
                GetIt.I<TopRatedMoviesUseCase>(),
                authRepository,
              )..add(LoadTopRatedMovies()),
        ),
      ],

      child: BlocBuilder<TrendingMoviesBloc, UiState>(
        builder: (context, state) {
          if (state is TrendingMoviesLoading) {
            _dialogShown = false; // Reset when loading starts
            return const Center(child: CircularProgressIndicator());
          } else if (state is TrendingMoviesLoaded) {
            _dialogShown = false; // Reset when loading starts
            return const MoviesScreenContent();
          } else if (state is ConnectionFailure) {
            if (!_dialogShown) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showNoInternetDialog(
                  context,
                  onRetry: () {
                    // Optional: Add your retry logic here!
                    context.read<TrendingMoviesBloc>().add(
                      LoadTrendingMovies(
                        selectedPeriod: 'day',
                        contentTypeId: 'movie',
                      ),
                    );
                  },
                );
              });
              _dialogShown = true;
            }
            return const SizedBox.shrink();
          } else {
            return const Center(
              child: Text('Something went wrong. Please try again.'),
            );
          }
        },
      ),
    );
  }
}
