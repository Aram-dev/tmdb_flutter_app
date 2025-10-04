import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../domain/models/movie.dart';

@RoutePage()
class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key, required this.movie});

  final Movie movie;

  static const _tabLabels = [
    'About',
    'Cast',
    'Comments',
    'Reviews',
    'Recommendations',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backdropUrl = movie.backdropPath != null
        ? 'https://image.tmdb.org/t/p/w780/${movie.backdropPath}'
        : null;
    final posterUrl = movie.posterPath != null
        ? 'https://image.tmdb.org/t/p/w342/${movie.posterPath}'
        : null;
    final voteAverage = movie.voteAverage != null
        ? movie.voteAverage!.toStringAsFixed(1)
        : '–';
    final voteCount = movie.voteCount?.toString() ?? '–';
    final releaseDate = movie.releaseDate ?? 'Unknown';
    final language = movie.originalLanguage?.toUpperCase() ?? 'N/A';
    final popularity = movie.popularity != null
        ? movie.popularity!.toStringAsFixed(0)
        : '–';

    final tabBar = TabBar(
      isScrollable: true,
      indicatorColor: theme.colorScheme.primary,
      labelColor: theme.colorScheme.primary,
      unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
      tabs: _tabLabels.map((label) => Tab(text: label)).toList(),
    );

    return DefaultTabController(
      length: _tabLabels.length,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: theme.colorScheme.surface,
              expandedHeight: 320,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(movie.title ?? 'Movie Details'),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (backdropUrl != null)
                      Image.network(backdropUrl, fit: BoxFit.cover)
                    else
                      Container(color: Colors.black12),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black54],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                tabBar: tabBar,
                backgroundColor: theme.colorScheme.surface,
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                children: [
                  _AboutTab(
                    movie: movie,
                    posterUrl: posterUrl,
                    releaseDate: releaseDate,
                    language: language,
                    voteAverage: voteAverage,
                    voteCount: voteCount,
                    popularity: popularity,
                  ),
                  const _PlaceholderTabContent(title: 'Cast'),
                  const _PlaceholderTabContent(title: 'Comments'),
                  const _PlaceholderTabContent(title: 'Reviews'),
                  const _PlaceholderTabContent(title: 'Recommendations'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutTab extends StatelessWidget {
  const _AboutTab({
    required this.movie,
    required this.posterUrl,
    required this.releaseDate,
    required this.language,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
  });

  final Movie movie;
  final String? posterUrl;
  final String releaseDate;
  final String language;
  final String voteAverage;
  final String voteCount;
  final String popularity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (posterUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    posterUrl!,
                    width: 120,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  width: 120,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                  child: const Icon(Icons.movie, size: 48),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title ?? 'Untitled',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _InfoChip(
                          icon: Icons.calendar_today,
                          label: releaseDate,
                        ),
                        _InfoChip(
                          icon: Icons.language,
                          label: language,
                        ),
                        _InfoChip(
                          icon: Icons.people,
                          label: 'Votes $voteCount',
                        ),
                        _InfoChip(
                          icon: Icons.trending_up,
                          label: 'Popularity $popularity',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(Icons.star, color: theme.colorScheme.secondary),
              const SizedBox(width: 8),
              Text(
                voteAverage,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text('User Score', style: textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Overview',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            movie.overview?.isNotEmpty == true
                ? movie.overview!
                : 'No overview available for this movie yet.',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Text(
            'Additional Details',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _InfoRow(
            title: 'Original Title',
            value: movie.originalTitle ?? '–',
          ),
          _InfoRow(title: 'Release Date', value: releaseDate),
          _InfoRow(title: 'Original Language', value: language),
          _InfoRow(
            title: 'Adult',
            value: movie.adult == true ? 'Yes' : 'No',
          ),
        ],
      ),
    );
  }
}

class _PlaceholderTabContent extends StatelessWidget {
  const _PlaceholderTabContent({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Text(
        '$title content coming soon',
        style: textTheme.titleMedium,
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate({required this.tabBar, required this.backgroundColor});

  final TabBar tabBar;
  final Color backgroundColor;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) {
    return oldDelegate.tabBar != tabBar ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      avatar: Icon(
        icon,
        size: 18,
        color: theme.colorScheme.onSecondaryContainer,
      ),
      label: Text(label),
      backgroundColor: theme.colorScheme.secondaryContainer,
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSecondaryContainer,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(title, style: textTheme.titleMedium),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
