import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:tmdb_flutter_app/features/movies/presentation/bloc/top_rated/top_rated_movies_bloc.dart';

import '../../domain/usecases/usecases.dart';

import '../../presentation/bloc/bloc.dart';
import '../bloc/base/base.dart';
import '../widgets/movie_card.dart';

@RoutePage()
class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final _trendingMoviesBloc = TrendingMoviesBloc(
    GetIt.I<TrendingMoviesUseCase>(),
  );
  final _popularMoviesBloc = PopularMoviesBloc(GetIt.I<PopularMoviesUseCase>());
  final _nowPlayingMoviesBloc = NowPlayingMoviesBloc(
    GetIt.I<NowPlayingMoviesUseCase>(),
  );
  final _upcomingMoviesBloc = UpcomingMoviesBloc(
    GetIt.I<UpcomingMoviesUseCase>(),
  );
  final _topRatedMoviesBloc = TopRatedMoviesBloc(
    GetIt.I<TopRatedMoviesUseCase>(),
  );

  @override
  void initState() {
    _trendingMoviesBloc.add(LoadTrendingMovies(selectedWindow: 'day'));
    _popularMoviesBloc.add(LoadPopularMovies());
    _nowPlayingMoviesBloc.add(LoadNowPlayingMovies());
    _upcomingMoviesBloc.add(LoadUpcomingMovies());
    _topRatedMoviesBloc.add(LoadTopRatedMovies());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TalkerScreen(talker: GetIt.I<Talker>()),
                ),
              );
            },
            icon: Icon(Icons.document_scanner_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trending Section
                BlocBuilder<TrendingMoviesBloc, MoviesState>(
                  bloc: _trendingMoviesBloc,
                  builder: (context, state) {
                    if (state is TrendingMoviesLoading) {
                      // Show a placeholder while loading
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is TrendingMoviesLoaded) {
                      // Header: title + toggle buttons for Today/This Week
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Trending",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              ToggleButtons(
                                isSelected: [
                                  state.currentWindow == 'day',
                                  state.currentWindow == 'week',
                                ],
                                onPressed: (index) {
                                  final selectedWindow =
                                      index == 0 ? 'day' : 'week';
                                      context.read<TrendingMoviesBloc>().add(
                                        LoadTrendingMovies(selectedWindow: selectedWindow),
                                      );
                                },
                                borderRadius: BorderRadius.circular(8),
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text("Today"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text("This Week"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Horizontal list of trending movies
                          SizedBox(
                            height: 180,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.trendingMovies.results?.length,
                              itemBuilder: (context, index) {
                                final movie =
                                    state.trendingMovies.results?[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: MovieCard(movie: movie),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 20),

                // Popular Section
                BlocBuilder<PopularMoviesBloc, MoviesState>(
                  bloc: _popularMoviesBloc,
                  builder: (context, state) {
                    if (state is PopularMoviesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is PopularMoviesLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Popular",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              // Genre filter chips
                              Wrap(
                                spacing: 8.0,
                                // children: Genre.values.map((genre) {
                                //   return ChoiceChip(
                                //     label: Text(genre.name),
                                //     selected: state.currentGenre == genre,
                                //     onSelected: (_) {
                                //       context.read<PopularMoviesBloc>().add(FilterPopularByGenre(genre));
                                //     },
                                //   );
                                // }).toList(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 180,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.popularMovies.results?.length,
                              itemBuilder: (context, index) {
                                final movie =
                                    state.popularMovies.results?[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: MovieCard(movie: movie),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 20),

                // Now Playing Section (Collapsible)
                BlocBuilder<NowPlayingMoviesBloc, MoviesState>(
                  bloc: _nowPlayingMoviesBloc,
                  builder: (context, state) {
                    // Always show the header
                    bool isExpanded = false;
                    List? movies = <dynamic>[]; // default
                    if (state is NowPlayingMoviesLoaded) {
                      isExpanded = state.isExpanded;
                      movies = state.nowPlayingMovies.results;
                    }
                    if (state is NowPlayingMoviesLoading) {
                      isExpanded = false;
                      movies = [];
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row with title and expand/collapse icon
                        Row(
                          children: [
                            const Text(
                              "Now Playing",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                              ),
                              onPressed: () {
                                context.read<NowPlayingMoviesBloc>().add(ToggleNowPlayingSection());
                              },
                            ),
                          ],
                        ),
                        // Movies list if expanded
                        if (isExpanded)
                          SizedBox(
                            height: 180,
                            child: (state is NowPlayingMoviesLoading)
                                ? // if loading and expanded, show a loader
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: movies?.length,
                                    itemBuilder: (context, index) {
                                      final movie = movies?[index] as dynamic;
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 12.0,
                                        ),
                                        child: MovieCard(movie: movie),
                                      );
                                    },
                                  ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Upcoming Section (Collapsible)
                BlocBuilder<UpcomingMoviesBloc, MoviesState>(
                  bloc: _upcomingMoviesBloc,
                  builder: (context, state) {
                    bool isExpanded = false;
                    List? movies = <dynamic>[];
                    if (state is UpcomingMoviesLoaded) {
                      isExpanded = state.isExpanded;
                      movies = state.upcomingMovies.results;
                    }
                    if (state is UpcomingMoviesLoading) {
                      isExpanded = false;
                      movies = [];
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Upcoming",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                              ),
                              onPressed: () {
                                context.read<UpcomingMoviesBloc>().add(ToggleUpcomingSection());
                              },
                            ),
                          ],
                        ),
                        if (isExpanded)
                          SizedBox(
                            height: 180,
                            child: (state is UpcomingMoviesLoading)
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: movies?.length,
                                    itemBuilder: (context, index) {
                                      final movie = movies?[index] as dynamic;
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 12.0,
                                        ),
                                        child: MovieCard(movie: movie),
                                      );
                                    },
                                  ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Top Rated Section (Collapsible)
                BlocBuilder<TopRatedMoviesBloc, MoviesState>(
                  bloc: _topRatedMoviesBloc,
                  builder: (context, state) {
                    bool isExpanded = false;
                    List? movies = <dynamic>[];
                    if (state is TopRatedMoviesLoaded) {
                      isExpanded = state.isExpanded;
                      movies = state.topRatedMovies.results;
                    }
                    if (state is TopRatedMoviesLoading) {
                      isExpanded = false;
                      movies = [];
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Top Rated",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                              ),
                              onPressed: () {
                                context.read<TopRatedMoviesBloc>().add(ToggleTopRatedSection());
                              },
                            ),
                          ],
                        ),
                        if (isExpanded)
                          SizedBox(
                            height: 180,
                            child: (state is TopRatedMoviesLoading)
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: movies?.length,
                                    itemBuilder: (context, index) {
                                      final movie = movies?[index] as dynamic;
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 12.0,
                                        ),
                                        child: MovieCard(movie: movie),
                                      );
                                    },
                                  ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
    );
  }
}