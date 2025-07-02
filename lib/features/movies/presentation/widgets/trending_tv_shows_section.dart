import 'package:flutter/material.dart';
import 'package:tmdb_flutter_app/features/movies/domain/models/movie.dart';
import 'package:tmdb_flutter_app/features/common/common.dart';
import '../../../tv_shows/presentation/bloc/trending/trending_tv_shows_bloc.dart';
import 'movie_card.dart';

class TrendingTvShowsSection extends StatefulWidget {
  final String? title;
  final String currentWindow;
  final List<Movie> tvShows;
  final void Function(UiEvent event) onPeriodChange;

  const TrendingTvShowsSection({
    super.key,
    required this.title,
    required this.tvShows,
    required this.currentWindow,
    required this.onPeriodChange,
  });

  @override
  State<TrendingTvShowsSection> createState() => _TrendingTvShowsSectionState();
}

class _TrendingTvShowsSectionState extends State<TrendingTvShowsSection>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(TrendingTvShowsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Trending",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: ToggleButtons(
                key: ValueKey(widget.currentWindow),
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
                  widget.currentWindow == 'day',
                  widget.currentWindow == 'week',
                ],
                onPressed: (index) {
                  final selectedPeriod = index == 0
                      ? 'day'
                      : 'week';
                  if (selectedPeriod ==
                      widget.currentWindow) {
                    return;
                  }

                  widget.onPeriodChange(
                    LoadTrendingTvShows(
                      selectedPeriod: selectedPeriod,
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

          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.tvShows
                  .map(
                    (tvShow) =>
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 12.0,
                      ),
                      child: MovieCard(
                        movie: tvShow,
                      ), // your MovieCard as you wrote above
                    ),
              )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
