import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/movie.dart';
import '../../domain/models/movie_credit.dart';
import '../../domain/models/movie_credits.dart';
import '../../domain/models/movie_detail.dart';
import '../../domain/models/movie_recommendation.dart';
import '../../domain/models/movie_recommendations.dart';
import '../../domain/models/movie_reviews.dart';
import '../../domain/models/movie_watch_providers.dart';
import '../../domain/models/watch_provider.dart';
import '../../domain/usecases/usecases.dart';
import '../bloc/movie_details/movie_details_bloc.dart';

@RoutePage()
class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({
    super.key,
    required this.movie,
    this.blocOverride,
  });

  final Movie movie;
  final MovieDetailsBloc? blocOverride;

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final movieId = widget.movie.id;
    if (movieId == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.movie.title ?? 'Movie Details')),
        body: const Center(
          child: Text('Movie details are unavailable for this title.'),
        ),
      );
    }

    final body = _MovieDetailsView(movie: widget.movie, movieId: movieId);

    final overrideBloc = widget.blocOverride;
    if (overrideBloc != null) {
      return BlocProvider<MovieDetailsBloc>.value(
        value: overrideBloc,
        child: body,
      );
    }

    return BlocProvider<MovieDetailsBloc>(
      create: (_) {
        final bloc = MovieDetailsBloc(
          movieDetailsUseCase: GetIt.I<MovieDetailsUseCase>(),
          movieCreditsUseCase: GetIt.I<MovieCreditsUseCase>(),
          movieReviewsUseCase: GetIt.I<MovieReviewsUseCase>(),
          movieRecommendationsUseCase: GetIt.I<MovieRecommendationsUseCase>(),
          movieWatchProvidersUseCase: GetIt.I<MovieWatchProvidersUseCase>(),
        );
        scheduleMicrotask(
          () => bloc.add(LoadMovieDetails(movieId: movieId)),
        );
        return bloc;
      },
      child: body,
    );
  }
}

class _MovieDetailsView extends StatelessWidget {
  const _MovieDetailsView({
    required this.movie,
    required this.movieId,
  });

  final Movie movie;
  final int movieId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
      builder: (context, state) {
        if (state is MovieDetailsFailure) {
          return Scaffold(
            appBar: AppBar(title: Text(movie.title ?? 'Movie #$movieId')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'We weren\'t able to load the movie details.\n${state.exception}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context
                          .read<MovieDetailsBloc>()
                          .add(LoadMovieDetails(movieId: movieId)),
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is MovieDetailsLoaded) {
          return _MovieDetailsContent(
            movie: movie,
            detail: state.detail,
            credits: state.credits,
            reviews: state.reviews,
            recommendations: state.recommendations,
            watchProviders: state.watchProviders,
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(movie.title ?? 'Movie #$movieId')),
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class _MovieDetailsContent extends StatelessWidget {
  const _MovieDetailsContent({
    required this.movie,
    required this.detail,
    required this.credits,
    required this.reviews,
    required this.recommendations,
    required this.watchProviders,
  });

  final Movie movie;
  final MovieDetail detail;
  final MovieCredits credits;
  final MovieReviews reviews;
  final MovieRecommendations recommendations;
  final MovieWatchProviders watchProviders;

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
    final releaseDateLabel = _formatReleaseDate(movie.releaseDate);
    final runtimeLabel =
        movie.runtime != null ? '${movie.runtime} mins' : null;
    final metadataParts = [
      if (releaseDateLabel != null) releaseDateLabel,
      if (runtimeLabel != null) runtimeLabel,
    ];
    final metadataText = metadataParts.join(' • ');
    final voteCount = movie.voteCount?.toString() ?? '–';
    final language = movie.originalLanguage?.toUpperCase() ?? 'N/A';
    final popularity = movie.popularity != null
        ? movie.popularity!.toStringAsFixed(0)
        : '–';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 340,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              title: Text(movie.title ?? 'Movie Details'),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (backdropUrl != null)
                    Image.network(backdropUrl, fit: BoxFit.cover)
                  else
                    Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 72,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.scrim.withOpacity(0.05),
                          theme.colorScheme.scrim.withOpacity(0.4),
                          theme.colorScheme.surface,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 24,
                    child: SafeArea(
                      top: false,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: FilledButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.play_circle_outline),
                          label: const Text('Watch Providers'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
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
          body: TabBarView(
            children: [
              _OverviewTab(detail: detail, movie: movie, credits: credits),
              _CastCrewTab(credits: credits),
              _ReviewsTab(reviews: reviews),
              _WatchProvidersTab(providers: watchProviders),
              _RecommendationsTab(recommendations: recommendations),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.detail,
    required this.movie,
    required this.credits,
  });

  final MovieDetail detail;
  final Movie movie;
  final MovieCredits credits;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final runtime = _formatRuntime(detail.runtime);
    final genres = detail.genres
        .map((g) => g.name)
        .whereType<String>()
        .where((name) => name.isNotEmpty)
        .toList();
    final posterUrl = _imageUrl(detail.posterPath ?? movie.posterPath, 'w342');
    final crewHighlights = _crewHighlights(credits);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: posterUrl != null
                  ? Image.network(
                      posterUrl,
                      width: 140,
                      height: 210,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 140,
                      height: 210,
                      color: theme.colorScheme.surfaceVariant,
                      child: const Icon(Icons.movie, size: 48),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PosterArtwork(posterUrl: posterUrl),
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
                            if (metadataText.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                metadataText,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _UserScoreIndicator(voteAverage: movie.voteAverage),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.star_border),
                                    label: const Text('Rate this movie'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _InfoChip(
                        icon: Icons.calendar_today,
                        label: releaseDateLabel ?? 'Unknown',
                      ),
                      if (runtimeLabel != null)
                        _InfoChip(
                          icon: Icons.schedule,
                          label: runtimeLabel,
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
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (detail.releaseDate != null && detail.releaseDate!.isNotEmpty)
                        _InfoChip(icon: Icons.calendar_today, label: detail.releaseDate!),
                      if (runtime != null)
                        _InfoChip(icon: Icons.access_time, label: runtime),
                      if (genres.isNotEmpty)
                        _InfoChip(icon: Icons.local_offer, label: genres.join(' • ')),
                      if (detail.voteAverage != null)
                        _InfoChip(
                          icon: Icons.star_rate,
                          label:
                              '${detail.voteAverage!.toStringAsFixed(1)} (${detail.voteCount ?? 0} votes)',
                        ),
                      if (detail.originalLanguage != null)
                        _InfoChip(
                          icon: Icons.language,
                          label: detail.originalLanguage!.toUpperCase(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Overview',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          (detail.overview ?? movie.overview ?? '').isNotEmpty
              ? (detail.overview ?? movie.overview!)
              : 'No overview available for this movie yet.',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        if (crewHighlights.isNotEmpty) ...[
          Text(
            'Featured Crew',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: crewHighlights
                .map(
                  (member) => SizedBox(
                    width: 160,
                    child: _CrewCard(member: member),
                  ),
                  _InfoRow(
                    title: 'Release Date',
                    value: releaseDateLabel ?? 'Unknown',
                  ),
                  if (runtimeLabel != null)
                    _InfoRow(title: 'Runtime', value: runtimeLabel),
                  _InfoRow(title: 'Original Language', value: language),
                  _InfoRow(
                    title: 'Adult',
                    value: movie.adult == true ? 'Yes' : 'No',
                  ),
                ],
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
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _PosterArtwork extends StatelessWidget {
  const _PosterArtwork({required this.posterUrl});

  final String? posterUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 120,
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: posterUrl != null
              ? Image.network(
                  posterUrl!,
                  fit: BoxFit.cover,
                )
              : Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.local_movies_outlined,
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
        ),
      ),
    );
  }
}

class _UserScoreIndicator extends StatelessWidget {
  const _UserScoreIndicator({required this.voteAverage});

  final double? voteAverage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final progress = voteAverage != null ? (voteAverage! / 10).clamp(0.0, 1.0) : null;
    final scoreLabel = voteAverage != null
        ? '${(progress! * 100).round()}%'
        : 'NR';

    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          if (progress != null)
            SizedBox(
              width: 72,
              height: 72,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 6,
                backgroundColor:
                    theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            )
          else
            SizedBox(
              width: 56,
              height: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.surface,
                ),
              ),
            ),
          Text(
            scoreLabel,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

String? _formatReleaseDate(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  try {
    final parsed = DateTime.parse(raw);
    return DateFormat('MMM yyyy').format(parsed);
  } catch (_) {
    return raw;
  }
}
