import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movie.dart';
import 'package:tmdb_flutter_app/features/movies/presentation/bloc/top_rated/top_rated_movies_bloc.dart';
import 'package:tmdb_flutter_app/features/movies/presentation/widgets/movies_section.dart';

import '../../domain/usecases/usecases.dart';

import '../../presentation/bloc/bloc.dart';
import '../bloc/common/common.dart';
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
  Widget build(
    BuildContext context,
  ) => BlocBuilder<TrendingMoviesBloc, MoviesState>(
    bloc: _trendingMoviesBloc,
    builder: (context, state) {
      if (state is TrendingMoviesLoading) {
        // Show a placeholder while loading
        return Center(child: CircularProgressIndicator());
      } else {
        return Scaffold(
          // resizeToAvoidBottomInset: true,
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
                      if (state is TrendingMoviesLoaded) {
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
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 100),
                                  child: ToggleButtons(
                                    key: ValueKey(state.currentWindow),
                                    borderRadius: BorderRadius.circular(20),
                                    constraints: const BoxConstraints(
                                      minHeight: 22,
                                      minWidth: 64,
                                    ),
                                    borderColor: Colors.grey,
                                    selectedBorderColor: Colors.blue,
                                    selectedColor: Colors.white,
                                    fillColor: Colors.blue,
                                    color: Colors.grey,
                                    isSelected: [
                                      state.currentWindow == 'day',
                                      state.currentWindow == 'week',
                                    ],
                                    onPressed: (index) {
                                      final selectedWindow = index == 0
                                          ? 'day'
                                          : 'week';
                                      if (selectedWindow == state.currentWindow) {
                                        return;
                                      }
                                      _trendingMoviesBloc.add(
                                        LoadTrendingMovies(
                                          selectedWindow: selectedWindow,
                                        ),
                                      );
                                    },
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Text(
                                          "Today",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Text(
                                          "This Week",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              transitionBuilder: (child, animation) =>
                                  FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0.1, 0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  ),
                              child: SizedBox(
                                key: ValueKey(
                                  state.trendingMovies.results?.length,
                                ),
                                height: 220,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      state.trendingMovies.results?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final movie =
                                        state.trendingMovies.results![index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        right: 12.0,
                                      ),
                                      child: MovieCard(movie: movie),
                                    );
                                  },
                                ),
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
                      bool isExpanded = false;
                      List<Movie> movies = []; // default
                      if (state is PopularMoviesLoading) {
                        isExpanded = false;
                        movies = [];
                      }
                      if (state is PopularMoviesLoaded) {
                        isExpanded = state.isExpanded;
                        movies =
                            state.popularMovies.results ??
                            List.empty(growable: false);
                      }

                      return MoviesSection(
                        title: "Popular",
                        state: state,
                        movies: movies,
                        isExpanded: isExpanded,
                        onToggleSection: (event) =>
                            _popularMoviesBloc.add(event),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Now Playing Section (Collapsible)
                  BlocBuilder<NowPlayingMoviesBloc, MoviesState>(
                    bloc: _nowPlayingMoviesBloc,
                    builder: (context, state) {
                      // Always show the header
                      bool isExpanded = false;
                      List<Movie> movies = []; // default
                      if (state is NowPlayingMoviesLoaded) {
                        isExpanded = state.isExpanded;
                        movies =
                            state.nowPlayingMovies.results ??
                            List.empty(growable: false);
                      }
                      if (state is NowPlayingMoviesLoading) {
                        isExpanded = false;
                        movies = [];
                      }
                      return MoviesSection(
                        title: "Now Playing",
                        state: state,
                        movies: movies,
                        isExpanded: isExpanded,
                        onToggleSection: (event) =>
                            _nowPlayingMoviesBloc.add(event),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Upcoming Section (Collapsible)
                  BlocBuilder<UpcomingMoviesBloc, MoviesState>(
                    bloc: _upcomingMoviesBloc,
                    builder: (context, state) {
                      bool isExpanded = false;
                      List<Movie> movies = [];
                      if (state is UpcomingMoviesLoaded) {
                        isExpanded = state.isExpanded;
                        movies =
                            state.upcomingMovies.results ??
                            List.empty(growable: false);
                      }
                      if (state is UpcomingMoviesLoading) {
                        isExpanded = false;
                        movies = List.empty();
                      }
                      return MoviesSection(
                        title: "Upcoming",
                        state: state,
                        movies: movies,
                        isExpanded: isExpanded,
                        onToggleSection: (event) =>
                            _upcomingMoviesBloc.add(event),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Top Rated Section (Collapsible)
                  BlocBuilder<TopRatedMoviesBloc, MoviesState>(
                    bloc: _topRatedMoviesBloc,
                    builder: (context, state) {
                      bool isExpanded = false;
                      List<Movie> movies = [];
                      if (state is TopRatedMoviesLoaded) {
                        isExpanded = state.isExpanded;
                        movies =
                            state.topRatedMovies.results ??
                            List.empty(growable: false);
                      }
                      if (state is TopRatedMoviesLoading) {
                        isExpanded = false;
                        movies = [];
                      }
                      return MoviesSection(
                        title: "Top Rated",
                        state: state,
                        movies: movies,
                        isExpanded: isExpanded,
                        onToggleSection: (event) =>
                            _topRatedMoviesBloc.add(event),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }
    },
  );
}
