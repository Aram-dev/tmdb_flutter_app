import 'package:flutter/material.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movie.dart';
import 'package:tmdb_flutter_app/features/common/common.dart';

import '../bloc/upcoming/upcoming_movies_bloc.dart';
import 'movie_card.dart';

class DiscoverDataSection extends StatefulWidget {
  final String? title;
  final bool isExpanded;
  final UiState state;
  final List<Movie> movies;
  final void Function(UiEvent event) onToggleSection;

  const DiscoverDataSection({
    super.key,
    required this.title,
    required this.state,
    required this.movies,
    required this.isExpanded,
    required this.onToggleSection,
  });

  @override
  State<DiscoverDataSection> createState() => _DiscoverDataSectionState();
}

class _DiscoverDataSectionState extends State<DiscoverDataSection>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(DiscoverDataSection oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: widget.state is UpcomingMoviesLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.movies
                    .map(
                      (movie) => Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: MovieCard(
                          movie: movie,
                        ), // your MovieCard as you wrote above
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }
}
