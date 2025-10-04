import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../auth/domain/repositories/auth_repository.dart';
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
class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({
    super.key,
    required this.movie,
    this.blocOverride,
  });

  final Movie movie;
  final MovieDetailsBloc? blocOverride;

  @override
  Widget build(BuildContext context) {
    final movieId = movie.id;
    if (movieId == null) {
      return Scaffold(
        appBar: AppBar(title: Text(movie.title ?? 'Movie Details')),
        body: const Center(
          child: Text('Movie details are unavailable for this title.'),
        ),
      );
    }

    final body = _MovieDetailsView(movie: movie, movieId: movieId);

    if (blocOverride != null) {
      return BlocProvider<MovieDetailsBloc>.value(
        value: blocOverride!,
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
          authRepository: GetIt.I<AuthRepository>(),
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
    final backgroundUrl = _imageUrl(detail.backdropPath ?? movie.backdropPath, 'w780');

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: theme.colorScheme.surface,
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(detail.title ?? movie.title ?? 'Movie Details'),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (backgroundUrl != null)
                      Image.network(backgroundUrl, fit: BoxFit.cover)
                    else
                      Container(color: theme.colorScheme.surfaceVariant),
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
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  color: theme.colorScheme.surface,
                  child: const TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(text: 'Overview'),
                      Tab(text: 'Cast & Crew'),
                      Tab(text: 'Reviews'),
                      Tab(text: 'Where to Watch'),
                      Tab(text: 'Recommendations'),
                    ],
                  ),
                ),
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
                  Text(
                    detail.title ?? movie.title ?? 'Untitled',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if ((detail.tagline ?? '').isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      detail.tagline!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontStyle: FontStyle.italic,
                      ),
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
                )
                .toList(),
          ),
          const SizedBox(height: 24),
        ],
        Text(
          'Facts',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _InfoRow(title: 'Original Title', value: detail.originalTitle ?? movie.originalTitle ?? '—'),
        _InfoRow(title: 'Status', value: detail.status ?? '—'),
        _InfoRow(title: 'Popularity', value: detail.popularity?.toStringAsFixed(0) ?? '—'),
        if (detail.homepage != null && detail.homepage!.isNotEmpty)
          _InfoRow(title: 'Homepage', value: detail.homepage!),
      ],
    );
  }
}

class _CastCrewTab extends StatelessWidget {
  const _CastCrewTab({required this.credits});

  final MovieCredits credits;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cast = [...credits.cast]..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    final crew = [...credits.crew];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Top Cast',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (cast.isEmpty)
          const Text('No cast information available.')
        else
          ...cast.take(12).map((member) => _PersonTile(member: member)),
        const SizedBox(height: 24),
        Text(
          'Key Crew',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (crew.isEmpty)
          const Text('No crew information available.')
        else
          ...crew
              .where((member) => (member.job ?? '').isNotEmpty)
              .take(12)
              .map((member) => _PersonTile(member: member)),
      ],
    );
  }
}

class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab({required this.reviews});

  final MovieReviews reviews;

  @override
  Widget build(BuildContext context) {
    if (reviews.results.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('No reviews have been written for this movie yet.'),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final review = reviews.results[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.author ?? 'Anonymous',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  review.content ?? 'No review text provided.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (review.createdAt != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Written on ${review.createdAt!.toLocal()}'.split('.').first,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).hintColor),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: reviews.results.length,
    );
  }
}

class _WatchProvidersTab extends StatelessWidget {
  const _WatchProvidersTab({required this.providers});

  final MovieWatchProviders providers;

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[];

    void addSection(String title, List<WatchProvider> items) {
      if (items.isEmpty) return;
      sections.add(Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ));
      sections.add(const SizedBox(height: 12));
      sections.addAll(
        items.map((item) => _ProviderTile(provider: item)),
      );
      sections.add(const SizedBox(height: 24));
    }

    addSection('Streaming', providers.flatrate);
    addSection('Rent', providers.rent);
    addSection('Buy', providers.buy);
    addSection('Ad-supported', providers.ads);
    addSection('Free', providers.free);

    if (sections.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('We couldn\'t find any watch providers for this region.'),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (providers.link != null && providers.link!.isNotEmpty) ...[
          Card(
            child: ListTile(
              leading: const Icon(Icons.open_in_new),
              title: const Text('View on TMDB'),
              subtitle: SelectableText(providers.link!),
            ),
          ),
          const SizedBox(height: 24),
        ],
        ...sections,
      ],
    );
  }
}

class _RecommendationsTab extends StatelessWidget {
  const _RecommendationsTab({required this.recommendations});

  final MovieRecommendations recommendations;

  @override
  Widget build(BuildContext context) {
    if (recommendations.results.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('No recommendations found yet.'),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: recommendations.results
              .take(12)
              .map((rec) => _RecommendationCard(recommendation: rec))
              .toList(),
        ),
      ],
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.recommendation});

  final MovieRecommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final posterUrl = _imageUrl(recommendation.posterPath, 'w185');
    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: posterUrl != null
                ? Image.network(
                    posterUrl,
                    width: 120,
                    height: 180,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 120,
                    height: 180,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: const Icon(Icons.movie),
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            recommendation.title ?? 'Untitled',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (recommendation.voteAverage != null)
            Text(
              recommendation.voteAverage!.toStringAsFixed(1),
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.secondary),
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
    final avatarUrl = _imageUrl(member.profilePath, 'w185');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
              child: avatarUrl == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(height: 12),
            Text(
              member.name ?? 'Unknown',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              member.job ?? 'Crew',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).hintColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonTile extends StatelessWidget {
  const _PersonTile({required this.member});

  final MovieCredit member;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = _imageUrl(member.profilePath, 'w185');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
        child: avatarUrl == null ? const Icon(Icons.person) : null,
      ),
      title: Text(member.name ?? 'Unknown'),
      subtitle: Text(member.role ?? '—'),
    );
  }
}

class _ProviderTile extends StatelessWidget {
  const _ProviderTile({required this.provider});

  final WatchProvider provider;

  @override
  Widget build(BuildContext context) {
    final logoUrl = _imageUrl(provider.logoPath, 'w92');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        backgroundImage: logoUrl != null ? NetworkImage(logoUrl) : null,
        child: logoUrl == null ? const Icon(Icons.live_tv) : null,
      ),
      title: Text(provider.providerName ?? 'Unknown'),
      subtitle: Text('Provider ID: ${provider.providerId ?? '—'}'),
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

String? _imageUrl(String? path, String size) {
  if (path == null || path.isEmpty) {
    return null;
  }
  return 'https://image.tmdb.org/t/p/$size$path';
}

String? _formatRuntime(int? runtime) {
  if (runtime == null || runtime <= 0) {
    return null;
  }
  final hours = runtime ~/ 60;
  final minutes = runtime % 60;
  if (hours == 0) {
    return '${minutes}m';
  }
  if (minutes == 0) {
    return '${hours}h';
  }
  return '${hours}h ${minutes}m';
}

List<MovieCredit> _crewHighlights(MovieCredits credits) {
  final highlights = <MovieCredit>[];
  final seenJobs = <String>{};
  for (final member in credits.crew) {
    final job = member.job;
    if (job == null || job.isEmpty) continue;
    final normalized = job.toLowerCase();
    if (seenJobs.contains(normalized)) continue;
    if (normalized.contains('director') ||
        normalized.contains('writer') ||
        normalized.contains('screenplay') ||
        normalized.contains('producer')) {
      highlights.add(member);
      seenJobs.add(normalized);
    }
    if (highlights.length >= 6) {
      break;
    }
  }
  return highlights;
}
