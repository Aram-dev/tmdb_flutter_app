import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tmdb_flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:tmdb_flutter_app/features/tv_shows/presentation/bloc/airing_today/airing_today_tv_shows_bloc.dart';
import 'package:tmdb_flutter_app/features/tv_shows/presentation/widgets/tv_shows_screen_content.dart';

import '../../../../core/connection/no_internet_dialog.dart';
import '../../domain/usecases/usecases.dart';

import '../../../common/common.dart';
import '../bloc/popular/popular_tv_shows_bloc.dart';
import '../bloc/top_rated/top_rated_tv_shows_bloc.dart';
import '../bloc/trending/trending_tv_shows_bloc.dart';

@RoutePage()
class TvShowsScreen extends StatefulWidget {
  const TvShowsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TvShowsScreenState();
}

class _TvShowsScreenState extends State<TvShowsScreen> {
  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    final authRepository = GetIt.I<AuthRepository>();
    return MultiBlocProvider(
      providers: [
        BlocProvider<TrendingTvShowsBloc>(
          create: (context) =>
              TrendingTvShowsBloc(
                GetIt.I<TrendingTvShowsUseCase>(),
                authRepository,
              )..add(LoadTrendingTvShows(selectedPeriod: 'day')),
        ),
        BlocProvider<PopularTvShowsBloc>(
          create: (context) =>
              PopularTvShowsBloc(
                GetIt.I<PopularTvShowsUseCase>(),
                authRepository,
              )..add(LoadPopularTvShows()),
        ),
        BlocProvider<TopRatedTvShowsBloc>(
          create: (context) =>
              TopRatedTvShowsBloc(
                GetIt.I<TopRatedTvShowsUseCase>(),
                authRepository,
              )..add(LoadTopRatedTvShows()),
        ),
        BlocProvider<AiringTodayTvShowsBloc>(
          create: (context) =>
              AiringTodayTvShowsBloc(
                GetIt.I<AiringTodayTvShowsUseCase>(),
                authRepository,
              )..add(LoadAiringTodayTvShows()),
        )
      ],
      child: BlocBuilder<TrendingTvShowsBloc, UiState>(
        builder: (context, state) {
          if (state is TrendingTvShowsLoading) {
            _dialogShown = false; // Reset when loading starts
            return const Center(child: CircularProgressIndicator());
          } else if (state is TrendingTvShowsLoaded) {
            _dialogShown = false; // Reset when loading starts
            return const TvShowsScreenContent();
          } else if (state is ConnectionFailure) {
            if (!_dialogShown) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showNoInternetDialog(
                  context,
                  onRetry: () {
                    // Optional: Add your retry logic here!
                    context.read<TrendingTvShowsBloc>().add(
                      LoadTrendingTvShows(selectedPeriod: 'day'),
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
