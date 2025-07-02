import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tmdb_flutter_app/features/movies/presentation/widgets/movies_section.dart';
import 'package:tmdb_flutter_app/features/tv_shows/presentation/bloc/airing_today/airing_today_tv_shows_bloc.dart';

import '../../../movies/presentation/widgets/trending_tv_shows_section.dart';
import '../../domain/usecases/airing_today/airing_today_tv_shows_use_case.dart';
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
  final _trendingTvShowsBloc = TrendingTvShowsBloc(
    GetIt.I<TrendingTvShowsUseCase>(),
  );
  final _popularTvShowsBloc = PopularTvShowsBloc(
    GetIt.I<PopularTvShowsUseCase>(),
  );
  final _topRatedTvShowsBloc = TopRatedTvShowsBloc(
    GetIt.I<TopRatedTvShowsUseCase>(),
  );
  final _airingTodayTvShowsBloc = AiringTodayTvShowsBloc(
    GetIt.I<AiringTodayTvShowsUseCase>(),
  );

  @override
  void initState() {
    _trendingTvShowsBloc.add(LoadTrendingTvShows(selectedPeriod: 'day'));
    _popularTvShowsBloc.add(LoadPopularTvShows());
    _topRatedTvShowsBloc.add(LoadTopRatedTvShows());
    _airingTodayTvShowsBloc.add(LoadAiringTodayTvShows());
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TrendingTvShowsBloc, UiState>(
        bloc: _trendingTvShowsBloc,
        builder: (context, state) {
          if (state is TrendingTvShowsLoading) {
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
                      BlocBuilder<TrendingTvShowsBloc, UiState>(
                        bloc: _trendingTvShowsBloc,
                        builder: (context, state) {
                          if (state is TrendingTvShowsLoaded) {
                            return TrendingTvShowsSection(
                              title: "Trending",
                              currentWindow: state.currentWindow,
                              tvShows:
                                  state.trendingContent.results ??
                                  List.empty(growable: false),
                              onPeriodChange: (event) =>
                                  _trendingTvShowsBloc.add(event),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      const SizedBox(height: 16),

                      // Popular Section
                      BlocBuilder<PopularTvShowsBloc, UiState>(
                        bloc: _popularTvShowsBloc,
                        builder: (context, state) {
                          bool isExpanded = false;
                          List<Movie> movies = []; // default
                          if (state is PopularTvShowsLoading) {
                            isExpanded = false;
                            movies = [];
                          }
                          if (state is PopularTvShowsLoaded) {
                            isExpanded = state.isExpanded;
                            movies =
                                state.popularTvShows.results ??
                                List.empty(growable: false);
                          }

                          return MoviesSection(
                            title: "Popular",
                            state: state,
                            movies: movies,
                            isExpanded: isExpanded,
                            onToggleSection: (event) =>
                                _popularTvShowsBloc.add(event),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Top Rated Section (Collapsible)
                      BlocBuilder<TopRatedTvShowsBloc, UiState>(
                        bloc: _topRatedTvShowsBloc,
                        builder: (context, state) {
                          bool isExpanded = false;
                          List<Movie> movies = [];
                          if (state is TopRatedTvShowsLoaded) {
                            isExpanded = state.isExpanded;
                            movies =
                                state.topRatedTvShows.results ??
                                List.empty(growable: false);
                          }
                          if (state is TopRatedTvShowsLoading) {
                            isExpanded = false;
                            movies = [];
                          }
                          return MoviesSection(
                            title: "Top Rated",
                            state: state,
                            movies: movies,
                            isExpanded: isExpanded,
                            onToggleSection: (event) =>
                                _topRatedTvShowsBloc.add(event),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Top Rated Section (Collapsible)
                      BlocBuilder<AiringTodayTvShowsBloc, UiState>(
                        bloc: _airingTodayTvShowsBloc,
                        builder: (context, state) {
                          bool isExpanded = false;
                          List<Movie> movies = [];
                          if (state is AiringTodayTvShowsLoaded) {
                            isExpanded = state.isExpanded;
                            movies =
                                state.airingTodayTvShows.results ??
                                    List.empty(growable: false);
                          }
                          if (state is TopRatedTvShowsLoading) {
                            isExpanded = false;
                            movies = [];
                          }
                          return MoviesSection(
                            title: "Airing Today",
                            state: state,
                            movies: movies,
                            isExpanded: isExpanded,
                            onToggleSection: (event) =>
                                _airingTodayTvShowsBloc.add(event),
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
