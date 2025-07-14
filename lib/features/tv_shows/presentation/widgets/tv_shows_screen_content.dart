import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/common.dart';
import '../../../movies/domain/models/movie.dart';
import '../../../movies/presentation/widgets/movies_section.dart';
import '../../../movies/presentation/widgets/trending_tv_shows_section.dart';
import '../bloc/airing_today/airing_today_tv_shows_bloc.dart';
import '../bloc/popular/popular_tv_shows_bloc.dart';
import '../bloc/top_rated/top_rated_tv_shows_bloc.dart';
import '../bloc/trending/trending_tv_shows_bloc.dart';

class TvShowsScreenContent extends StatefulWidget {
  const TvShowsScreenContent({super.key});

  @override
  State<StatefulWidget> createState() => _MoviesScreenContentState();
}

class _MoviesScreenContentState extends State<StatefulWidget>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              builder: (context, state) {
                if (state is TrendingTvShowsLoaded) {
                  return TrendingTvShowsSection(
                    title: "Trending",
                    currentWindow: state.currentWindow,
                    tvShows:
                    state.trendingContent.results ??
                        List.empty(growable: false),
                    onPeriodChange: (event) =>
                        context.read<TrendingTvShowsBloc>().add(event),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            const SizedBox(height: 12),

            // Popular Section
            BlocBuilder<PopularTvShowsBloc, UiState>(
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
                      context.read<PopularTvShowsBloc>().add(event),
                );
              },
            ),
            const SizedBox(height: 12),

            // Top Rated Section (Collapsible)
            BlocBuilder<TopRatedTvShowsBloc, UiState>(
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
                      context.read<TopRatedTvShowsBloc>().add(event),
                );
              },
            ),
            const SizedBox(height: 12),

            // Top Rated Section (Collapsible)
            BlocBuilder<AiringTodayTvShowsBloc, UiState>(
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
                      context.read<AiringTodayTvShowsBloc>().add(event),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}