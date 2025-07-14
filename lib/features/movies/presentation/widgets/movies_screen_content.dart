import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter_app/features/movies/presentation/widgets/trending_movies_section.dart';

import '../../../common/common.dart';
import '../../domain/models/movie.dart';
import '../bloc/now_playing/now_playing_movies_bloc.dart';
import '../bloc/popular/popular_movies_bloc.dart';
import '../bloc/top_rated/top_rated_movies_bloc.dart';
import '../bloc/trending/trending_movies_bloc.dart';
import '../bloc/upcoming/upcoming_movies_bloc.dart';
import 'movies_section.dart';

class MoviesScreenContent extends StatefulWidget {
  const MoviesScreenContent({super.key});

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
            BlocBuilder<TrendingMoviesBloc, UiState>(
              builder: (context, state) {
                if (state is TrendingMoviesLoaded) {
                  return TrendingMoviesSection(
                    title: "Trending",
                    currentWindow: state.currentWindow,
                    movies:
                    state.trendingMovies.results ??
                        List.empty(growable: false),
                    onPeriodChange: (event) =>
                        context.read<TrendingMoviesBloc>().add(event),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            const SizedBox(height: 12),

            // Popular Section
            BlocBuilder<PopularMoviesBloc, UiState>(
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
                      context.read<PopularMoviesBloc>().add(event),
                );
              },
            ),
            const SizedBox(height: 12),

            // Now Playing Section (Collapsible)
            BlocBuilder<NowPlayingMoviesBloc, UiState>(
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
                      context.read<NowPlayingMoviesBloc>().add(event),
                );
              },
            ),
            const SizedBox(height: 12),

            // Upcoming Section (Collapsible)
            BlocBuilder<UpcomingMoviesBloc, UiState>(
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
                      context.read<UpcomingMoviesBloc>().add(event),
                );
              },
            ),
            const SizedBox(height: 12),

            // Top Rated Section (Collapsible)
            BlocBuilder<TopRatedMoviesBloc, UiState>(
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
                      context.read<TopRatedMoviesBloc>().add(event),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}