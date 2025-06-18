import 'package:flutter/material.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movie.dart';
import 'package:tmdb_flutter_app/features/common/common.dart';

import '../bloc/upcoming/upcoming_movies_bloc.dart';
import 'movie_card.dart';

class MoviesSection extends StatefulWidget {
  final String? title;
  final bool isExpanded;
  final MoviesState state;
  final List<Movie> movies;
  final void Function(MoviesEvent event) onToggleSection;

  const MoviesSection({
    super.key,
    required this.title,
    required this.state,
    required this.movies,
    required this.isExpanded,
    required this.onToggleSection,
  });

  @override
  State<MoviesSection> createState() => _MoviesSectionState();
}

class _MoviesSectionState extends State<MoviesSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.isExpanded) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(MoviesSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      widget.isExpanded ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () => widget.onToggleSection(ToggleSection()),
              borderRadius: BorderRadius.circular(12),
              splashColor: Color.alphaBlend(
                colorScheme.primary.withAlpha(31),
                colorScheme.surface,
              ),
              child: Ink(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      widget.title ?? "",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    AnimatedRotation(
                      turns: widget.isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(Icons.expand_more, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        SizeTransition(
          sizeFactor: _expandAnimation,
          axisAlignment: -1,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: SizedBox(
              height: 220,
              child: widget.state is UpcomingMoviesLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.movies.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final movie = widget.movies[index];
                        return MovieCard(movie: movie);
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
