import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/common.dart';
import '../../../movies/presentation/bloc/trending/trending_movies_bloc.dart';
import '../../../movies/presentation/widgets/discover_data_section.dart';
import '../../../movies/presentation/widgets/trending_movies_section.dart';
import '../bloc/discover_movies/discover_movies_bloc.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<StatefulWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      final category = _tabController.index == 0 ? 'movie' : 'tv';
      // No need to create a new bloc! Just use context:
      context.read<DiscoverContentBloc>().add(LoadDiscoverContent(category: category));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    context.read<DiscoverContentBloc>().close();
    super.dispose();
  }

  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
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
                    indicatorColor: Colors.white,
                    labelStyle: const TextStyle(fontSize: 16, color: Colors.white),
                    unselectedLabelStyle: const TextStyle(fontSize: 16, color: Colors.white70),
                    tabs: const [
                      Tab(text: 'Movies'),
                      Tab(text: 'TV Shows'),
                    ],
                  ),
                  BlocBuilder<DiscoverContentBloc, UiState>(
                    builder: (context, state) {
                      if (state is DiscoverContentLoaded) {
                        final movies = state.discoverMovies.results ?? [];
                        return DiscoverDataSection(
                          title: null,
                          state: state,
                          movies: movies,
                          isExpanded: true,
                          onToggleSection: (event) =>
                              context.read<DiscoverContentBloc>().add(event),
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
              builder: (context, state) {
                if (state is TrendingMoviesLoaded) {
                  return TrendingMoviesSection(
                    title: "Trending",
                    currentWindow: state.currentWindow,
                    movies: state.trendingMovies.results ?? List.empty(growable: false),
                    onPeriodChange: (event) =>
                        context.read<TrendingMoviesBloc>().add(event),
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
}
