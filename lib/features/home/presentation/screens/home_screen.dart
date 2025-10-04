import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tmdb_flutter_app/core/connection/no_internet_dialog.dart';

import '../../../common/common.dart';
import '../../../movies/domain/usecases/trending/trending_movies_use_case.dart';
import '../../../movies/presentation/bloc/trending/trending_movies_bloc.dart';
import '../../domain/usecases/discover_movies/discover_movies_use_case.dart';
import '../bloc/discover_movies/discover_movies_bloc.dart';
import '../widgets/home_screen_content.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DiscoverContentBloc>(
          create: (context) =>
              DiscoverContentBloc(
                GetIt.I<DiscoverContentUseCase>(),
              )..add(LoadDiscoverContent(category: 'movie')),
        ),
        BlocProvider<TrendingMoviesBloc>(
          create: (context) =>
              TrendingMoviesBloc(
                GetIt.I<TrendingMoviesUseCase>(),
              )..add(
                LoadTrendingMovies(
                  selectedPeriod: 'day',
                  contentTypeId: 'movie',
                ),
              ),
        ),
      ],
      child: BlocBuilder<DiscoverContentBloc, UiState>(
        builder: (context, state) {
          if (state is DiscoverContentLoading) {
            _dialogShown = false; // Reset when loading starts
            return const Center(child: CircularProgressIndicator());
          } else if (state is DiscoverContentLoaded) {
            _dialogShown = false; // Reset if data loads successfully
            return const HomeScreenContent();
          } else if (state is ConnectionFailure) {
            if (!_dialogShown) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showNoInternetDialog(
                  context,
                  onRetry: () {
                    // Optional: Add your retry logic here!
                    context.read<DiscoverContentBloc>().add(
                      LoadDiscoverContent(category: 'movie'),
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
