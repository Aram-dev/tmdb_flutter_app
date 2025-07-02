import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movie.dart';
import 'package:tmdb_flutter_app/features/movies/presentation/bloc/top_rated/top_rated_movies_bloc.dart';
import 'package:tmdb_flutter_app/features/movies/presentation/widgets/movies_section.dart';

import '../../domain/usecases/usecases.dart';

import '../../presentation/bloc/bloc.dart';
import '../../../common/common.dart';
import '../widgets/trending_movies_section.dart';

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
    _trendingMoviesBloc.add(LoadTrendingMovies(selectedPeriod: 'day', contentTypeId: 'movie'));
    _popularMoviesBloc.add(LoadPopularMovies());
    _nowPlayingMoviesBloc.add(LoadNowPlayingMovies());
    _upcomingMoviesBloc.add(LoadUpcomingMovies());
    _topRatedMoviesBloc.add(LoadTopRatedMovies());
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TrendingMoviesBloc, UiState>(
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 8.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

                      const SizedBox(height: 20),

                      // Popular Section
                      BlocBuilder<PopularMoviesBloc, UiState>(
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
                      BlocBuilder<NowPlayingMoviesBloc, UiState>(
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
                      BlocBuilder<UpcomingMoviesBloc, UiState>(
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
                      BlocBuilder<TopRatedMoviesBloc, UiState>(
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
