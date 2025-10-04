import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/movie.dart';

@RoutePage()
class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
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
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
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
            ),
          ),
        ],
      ),
    );
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
