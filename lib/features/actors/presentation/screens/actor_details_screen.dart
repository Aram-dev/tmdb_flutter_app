import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../common/common.dart';
import '../../domain/models/actor_credit.dart';
import '../../domain/models/actors_list_result.dart';
import '../../domain/models/actors_list_result_known_for.dart';
import '../../domain/usecases/usecases.dart';
import '../bloc/actor_details/actor_details_bloc.dart';

@RoutePage()
class ActorDetailsScreen extends StatelessWidget {
  const ActorDetailsScreen({
    super.key,
    required this.actorId,
    this.initialActor,
  });

  final int actorId;
  final ActorsListResults? initialActor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActorDetailsBloc>(
      create: (_) => ActorDetailsBloc(
        actorDetailsUseCase: GetIt.I<ActorDetailsUseCase>(),
        initialActor: initialActor,
      )..add(FetchActorDetails(actorId: actorId, initialActor: initialActor)),
      child: _ActorDetailsView(
        actorId: actorId,
        initialActor: initialActor,
      ),
    );
  }
}

class _ActorDetailsView extends StatelessWidget {
  const _ActorDetailsView({required this.actorId, this.initialActor});

  final int actorId;
  final ActorsListResults? initialActor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActorDetailsBloc, UiState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final details = state is ActorDetailsLoaded ? state.details : null;
        final fallback = _fallbackActor(state) ?? initialActor;
        final isLoading =
            state is ActorDetailsLoading || state is ActorDetailsInitial;
        final hasError = state is ActorDetailsFailure;
        final error = hasError ? state.exception : null;

        final displayName = details?.name ?? fallback?.name ?? 'Actor';
        final profilePath = details?.profilePath ?? fallback?.profilePath;
        final department =
            details?.knownForDepartment ?? fallback?.knownForDepartment;
        final biography = details?.biography;
        final primaryCredits = details?.cast ?? const [];
        final crewCredits = details?.crew ?? const [];
        final placeholderCredits = fallback?.knownFor ?? const [];

        final profileUrl = (profilePath != null && profilePath.isNotEmpty)
            ? 'https://image.tmdb.org/t/p/w500$profilePath'
            : null;

        return Scaffold(
          appBar: AppBar(
            title: Text(displayName),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<ActorDetailsBloc>().add(
                      FetchActorDetails(
                        actorId: actorId,
                        initialActor: fallback,
                      ),
                    );
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: profileUrl != null
                            ? Image.network(
                                profileUrl,
                                width: 140,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _profilePlaceholder(),
                              )
                            : _profilePlaceholder(),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (department != null && department.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  department,
                                  style: theme.textTheme.titleMedium,
                                ),
                              ),
                            if (isLoading)
                              const Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: LinearProgressIndicator(),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(title: 'Biography'),
                  const SizedBox(height: 8),
                  if (isLoading && (biography == null || biography.isEmpty))
                    const Text('Loading biography...')
                  else if (biography != null && biography.trim().isNotEmpty)
                    Text(biography.trim())
                  else
                    const Text('No biography available for this actor.'),
                  if (hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: _ErrorMessage(
                        error: error,
                        onRetry: () {
                          context.read<ActorDetailsBloc>().add(
                                FetchActorDetails(
                                  actorId: actorId,
                                  initialActor: fallback,
                                ),
                              );
                        },
                      ),
                    ),
                  const SizedBox(height: 24),
                  _SectionTitle(title: 'Credits'),
                  const SizedBox(height: 8),
                  if (primaryCredits.isNotEmpty)
                    _CreditsList(credits: primaryCredits)
                  else if (isLoading && placeholderCredits.isNotEmpty)
                    _KnownForList(knownFor: placeholderCredits)
                  else if (crewCredits.isNotEmpty)
                    _CreditsList(credits: crewCredits)
                  else
                    const Text('No credits found yet.'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ActorsListResults? _fallbackActor(UiState state) {
    if (state is ActorDetailsInitial) return state.initialActor;
    if (state is ActorDetailsLoading) return state.initialActor;
    if (state is ActorDetailsFailure) return state.initialActor;
    return null;
  }

  Widget _profilePlaceholder() => Container(
        width: 140,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.person, size: 48, color: Colors.black45),
      );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class _CreditsList extends StatelessWidget {
  const _CreditsList({required this.credits});

  final List<ActorCredit> credits;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: credits.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final credit = credits[index];
          final posterPath = credit.posterPath;
          final posterUrl =
              posterPath != null ? 'https://image.tmdb.org/t/p/w300$posterPath' : null;
          final title = credit.displayTitle ?? 'Untitled';
          final subtitle = credit.character ?? credit.job;

          return SizedBox(
            width: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: posterUrl != null
                      ? Image.network(
                          posterUrl,
                          height: 180,
                          width: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _posterPlaceholder(),
                        )
                      : _posterPlaceholder(),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (subtitle != null && subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _posterPlaceholder() => Container(
        height: 180,
        width: 140,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.movie, color: Colors.black45),
      );
}

class _KnownForList extends StatelessWidget {
  const _KnownForList({required this.knownFor});

  final List<ActorsListResultsKnownFor> knownFor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: knownFor.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = knownFor[index];
          final posterPath = item.posterPath;
          final posterUrl = posterPath != null
              ? 'https://image.tmdb.org/t/p/w300$posterPath'
              : null;
          final title = item.title ?? item.originalTitle ?? item.name ?? 'Untitled';

          return SizedBox(
            width: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: posterUrl != null
                      ? Image.network(
                          posterUrl,
                          height: 160,
                          width: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _posterPlaceholder(),
                        )
                      : _posterPlaceholder(),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _posterPlaceholder() => Container(
        height: 160,
        width: 140,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.movie, color: Colors.black45),
      );
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.error, required this.onRetry});

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Failed to load details',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onErrorContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error?.toString() ?? 'Something went wrong.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
