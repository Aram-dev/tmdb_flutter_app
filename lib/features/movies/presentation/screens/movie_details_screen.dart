import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../domain/models/movie.dart';
import '../../domain/models/movie_credit.dart';
import '../../domain/models/movie_credits.dart';
import '../../domain/models/movie_detail.dart';
import '../../domain/models/movie_recommendation.dart';
import '../../domain/models/movie_recommendations.dart';
import '../../domain/models/movie_review.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final title = detail.title ?? movie.title ?? 'Movie Details';
    final backdropUrl = _imageUrl(detail.backdropPath ?? movie.backdropPath, 'w780');
    final posterUrl = _imageUrl(detail.posterPath ?? movie.posterPath, 'w342');
    final releaseDateLabel = _formatReleaseDate(detail.releaseDate ?? movie.releaseDate);
    final runtimeLabel = _formatRuntime(detail.runtime ?? movie.runtime);
    final originalLanguage =
        (detail.originalLanguage ?? movie.originalLanguage)?.toUpperCase();
    final metadataParts = <String>[
      if (releaseDateLabel != null) releaseDateLabel,
      if (runtimeLabel != null) runtimeLabel,
      if (originalLanguage != null && originalLanguage.isNotEmpty)
        originalLanguage,
    ];
    final metadataText = metadataParts.join(' • ');

    final tagline = detail.tagline?.trim();
    final overview =
        (detail.overview?.trim().isNotEmpty == true ? detail.overview?.trim() : null) ??
            (movie.overview?.trim().isNotEmpty == true
                ? movie.overview!.trim()
                : null);
    final genres = detail.genres
        .map((genre) => genre.name)
        .whereType<String>()
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    final voteAverage = detail.voteAverage ?? movie.voteAverage;
    final voteCount = detail.voteCount ?? movie.voteCount;

    final featuredCrew = _selectFeaturedCrew(credits);
    final castMembers = credits.cast
        .where((member) => member.name?.isNotEmpty == true)
        .take(12)
        .toList();
    final reviewItems = reviews.results
        .where((review) => review.content?.trim().isNotEmpty == true)
        .toList();
    final recommendationItems = recommendations.results
        .where((rec) => rec.id != null && rec.title?.isNotEmpty == true)
        .toList();

    final providerGroups = <_ProviderGroup>[
      if (watchProviders.flatrate.isNotEmpty)
        _ProviderGroup('Stream', watchProviders.flatrate),
      if (watchProviders.rent.isNotEmpty)
        _ProviderGroup('Rent', watchProviders.rent),
      if (watchProviders.buy.isNotEmpty)
        _ProviderGroup('Buy', watchProviders.buy),
      if (watchProviders.ads.isNotEmpty)
        _ProviderGroup('With ads', watchProviders.ads),
      if (watchProviders.free.isNotEmpty)
        _ProviderGroup('Free', watchProviders.free),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
              background: _BackdropImage(backdropUrl: backdropUrl),
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
                              title,
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
                            if (tagline?.isNotEmpty == true) ...[
                              const SizedBox(height: 12),
                              Text(
                                tagline!,
                                style: textTheme.titleMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                            if (voteAverage != null) ...[
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  _UserScoreIndicator(voteAverage: voteAverage),
                                  const SizedBox(width: 12),
                                  Text(
                                    voteCount != null
                                        ? 'User score based on $voteCount votes'
                                        : 'User score',
                                    style: textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (genres.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: genres
                          .map(
                            (genre) => Chip(
                              label: Text(genre),
                              backgroundColor:
                                  theme.colorScheme.secondaryContainer,
                              labelStyle: textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  if (overview != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Overview',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      overview,
                      style: textTheme.bodyLarge,
                    ),
                  ],
                  if (featuredCrew.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Featured crew',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: featuredCrew
                          .map(
                            (member) => SizedBox(
                              width: min(MediaQuery.of(context).size.width / 2 - 32, 180),
                              child: _CrewCard(member: member),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  if (castMembers.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Cast',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 220,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => _CastCard(
                          member: castMembers[index],
                        ),
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemCount: castMembers.length,
                      ),
                    ),
                  ],
                  if (reviewItems.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Reviews',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(
                      min(reviewItems.length, 3),
                      (index) {
                        final review = reviewItems[index];
                        final isLast = index == min(reviewItems.length, 3) - 1;
                        return Padding(
                          padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                          child: _ReviewCard(review: review),
                        );
                      },
                    ),
                  ],
                  if (providerGroups.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Where to watch',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...providerGroups.map(
                      (group) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.title,
                              style: textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: group.providers
                                  .map(
                                    (provider) => _WatchProviderChip(
                                      provider: provider,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (recommendationItems.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Recommendations',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 230,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => _RecommendationCard(
                          recommendation: recommendationItems[index],
                        ),
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemCount: recommendationItems.length,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackdropImage extends StatelessWidget {
  const _BackdropImage({required this.backdropUrl});

  final String? backdropUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        if (backdropUrl != null)
          Image.network(
            backdropUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _BackdropPlaceholder(theme: theme),
          )
        else
          _BackdropPlaceholder(theme: theme),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.surface.withOpacity(0.0),
                theme.colorScheme.surface.withOpacity(0.3),
                theme.colorScheme.surface,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BackdropPlaceholder extends StatelessWidget {
  const _BackdropPlaceholder({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.movie_filter_outlined,
        size: 72,
        color: theme.colorScheme.onSurfaceVariant,
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
        width: 140,
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: posterUrl != null
              ? Image.network(
                  posterUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _PosterPlaceholder(theme: theme),
                )
              : _PosterPlaceholder(theme: theme),
        ),
      ),
    );
  }
}

class _PosterPlaceholder extends StatelessWidget {
  const _PosterPlaceholder({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.local_movies_outlined,
        size: 48,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _UserScoreIndicator extends StatelessWidget {
  const _UserScoreIndicator({required this.voteAverage});

  final double voteAverage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final progress = (voteAverage / 10).clamp(0.0, 1.0);

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
          ),
          Text(
            '${(progress * 100).round()}%',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CrewCard extends StatelessWidget {
  const _CrewCard({required this.member});

  final MovieCredit member;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          member.name ?? 'Unknown',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          member.job ?? '—',
          style: textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _CastCard extends StatelessWidget {
  const _CastCard({required this.member});

  final MovieCredit member;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final profileUrl = _imageUrl(member.profilePath, 'w185');

    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: profileUrl != null
                  ? Image.network(
                      profileUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _CastPlaceholder(theme: theme),
                    )
                  : _CastPlaceholder(theme: theme),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            member.name ?? 'Unknown',
            style: textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (member.role?.isNotEmpty == true) ...[
            const SizedBox(height: 2),
            Text(
              member.role!,
              style: textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _CastPlaceholder extends StatelessWidget {
  const _CastPlaceholder({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.person_outline,
        size: 48,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final MovieReview review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final author = review.author?.trim();
    final content = review.content?.trim();
    final createdAt = review.createdAt != null
        ? DateFormat.yMMMd().format(review.createdAt!.toLocal())
        : null;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (author != null && author.isNotEmpty)
              Text(
                'Review by $author',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (createdAt != null) ...[
              const SizedBox(height: 4),
              Text(
                createdAt,
                style: textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (author != null && author.isNotEmpty || createdAt != null)
              const SizedBox(height: 12),
            Text(
              content ?? 'No review content provided.',
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.recommendation});

  final MovieRecommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final posterUrl = _imageUrl(recommendation.posterPath, 'w185');
    final releaseDate = _formatReleaseDate(recommendation.releaseDate);

    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: posterUrl != null
                  ? Image.network(
                      posterUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _PosterPlaceholder(theme: theme),
                    )
                  : _PosterPlaceholder(theme: theme),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            recommendation.title ?? recommendation.originalTitle ?? 'Unknown',
            style: textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (releaseDate != null) ...[
            const SizedBox(height: 2),
            Text(
              releaseDate,
              style: textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (recommendation.voteAverage != null) ...[
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.star, size: 16),
                const SizedBox(width: 4),
                Text(
                  recommendation.voteAverage!.toStringAsFixed(1),
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _WatchProviderChip extends StatelessWidget {
  const _WatchProviderChip({required this.provider});

  final WatchProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoUrl = _imageUrl(provider.logoPath, 'w92');
    return Chip(
      avatar: logoUrl != null
          ? CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(logoUrl),
            )
          : const CircleAvatar(
              child: Icon(Icons.tv),
            ),
      label: Text(provider.providerName ?? 'Unknown'),
      backgroundColor: theme.colorScheme.secondaryContainer,
      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSecondaryContainer,
          ),
    );
  }
}

class _ProviderGroup {
  const _ProviderGroup(this.title, this.providers);

  final String title;
  final List<WatchProvider> providers;
}

List<MovieCredit> _selectFeaturedCrew(MovieCredits credits) {
  const preferredJobs = <String>{
    'Director',
    'Screenplay',
    'Writer',
    'Producer',
  };

  final preferred = <MovieCredit>[];
  final others = <MovieCredit>[];

  for (final member in credits.crew) {
    if (member.name?.isNotEmpty != true || member.job?.isNotEmpty != true) {
      continue;
    }
    if (preferredJobs.contains(member.job)) {
      preferred.add(member);
    } else {
      others.add(member);
    }
  }

  final seen = <String>{};
  final result = <MovieCredit>[];
  for (final list in [preferred, others]) {
    for (final member in list) {
      final key = '${member.name}-${member.job}';
      if (seen.add(key)) {
        result.add(member);
      }
      if (result.length == 6) {
        return result;
      }
    }
  }

  return result;
}

String? _imageUrl(String? path, String size) {
  if (path == null || path.isEmpty) {
    return null;
  }
  return 'https://image.tmdb.org/t/p/$size$path';
}

String? _formatReleaseDate(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  try {
    final parsed = DateTime.parse(raw);
    return DateFormat.yMMMd().format(parsed);
  } catch (_) {
    return raw;
  }
}

String? _formatRuntime(int? minutes) {
  if (minutes == null || minutes <= 0) {
    return null;
  }
  final hours = minutes ~/ 60;
  final remainingMinutes = minutes % 60;
  if (hours == 0) {
    return '${remainingMinutes}m';
  }
  return remainingMinutes == 0
      ? '${hours}h'
      : '${hours}h ${remainingMinutes}m';
}
