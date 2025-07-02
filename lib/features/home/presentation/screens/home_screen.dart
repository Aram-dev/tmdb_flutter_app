import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../common/common.dart';
import '../../../movies/domain/usecases/trending/trending_movies_use_case.dart';
import '../../../movies/presentation/bloc/trending/trending_movies_bloc.dart';
import '../../../movies/presentation/widgets/discover_data_section.dart';
import '../../../movies/presentation/widgets/movies_section.dart';
import '../../../movies/presentation/widgets/trending_movies_section.dart';
import '../../domain/usecases/discover_movies/discover_movies_use_case.dart';
import '../bloc/discover_movies/discover_movies_bloc.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _discoverMoviesBloc = DiscoverContentBloc(
    GetIt.I<DiscoverContentUseCase>(),
  );
  final _trendingMoviesBloc = TrendingMoviesBloc(
    GetIt.I<TrendingMoviesUseCase>(),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _discoverMoviesBloc.add(LoadDiscoverContent(category: 'movie'));
    _trendingMoviesBloc.add(
      LoadTrendingMovies(selectedPeriod: 'day', contentTypeId: 'movie'),
    );

    _tabController.addListener(() {
      final category = _tabController.index == 0 ? 'movie' : 'tv';
      _discoverMoviesBloc.add(LoadDiscoverContent(category: category));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _discoverMoviesBloc.close();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<DiscoverContentBloc, UiState>(
    bloc: _discoverMoviesBloc,
    builder: (context, state) {
      if (state is DiscoverContentLoading) {
        // Show a placeholder while loading
        return Center(child: CircularProgressIndicator());
      } else {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        child: Text(
                          'Discover',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: Colors.blueAccent,
                        labelColor: Colors.blueAccent,
                        unselectedLabelColor: Colors.grey,
                        tabs: const [
                          Tab(text: 'Movies'),
                          Tab(text: 'TV Shows'),
                        ],
                      ),
                      BlocBuilder<DiscoverContentBloc, UiState>(
                        bloc: _discoverMoviesBloc,
                        builder: (context, state) {
                          if (state is DiscoverContentLoaded) {
                            final movies = state.discoverMovies.results ?? [];
                            return DiscoverDataSection(
                              title: null,
                              state: state,
                              movies: movies,
                              isExpanded: true,
                              onToggleSection: (event) =>
                                  _discoverMoviesBloc.add(event),
                            );
                          } else if (state is DiscoverContentLoadingFailure) {
                            return Center(
                              child: Text(state.exception.toString()),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),

                // Trending Section
                BlocBuilder<TrendingMoviesBloc, UiState>(
                  bloc: _trendingMoviesBloc,
                  builder: (context, state) {
                    if (state is TrendingMoviesLoaded) {
                      return TrendingMoviesSection(
                        title: "Trending",
                        currentWindow: state.currentWindow,
                        movies:
                            state.trendingMovies.results ??
                            List.empty(growable: false),
                        onPeriodChange: (event) =>
                            _trendingMoviesBloc.add(event),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        );
      }
    },
  );
}
