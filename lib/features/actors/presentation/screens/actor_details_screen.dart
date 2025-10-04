import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/usecases/usecases.dart';
import '../bloc/actor_details_bloc.dart';
import 'package:tmdb_flutter_app/features/auth/domain/repositories/auth_repository.dart';

@RoutePage()
class ActorDetailsScreen extends StatelessWidget {
  const ActorDetailsScreen({
    super.key,
    required this.actorId,
    this.actorName,
    this.blocOverride,
  });

  final int actorId;
  final String? actorName;
  final ActorDetailsBloc? blocOverride;

  @override
  Widget build(BuildContext context) {
    final body = _ActorDetailsView(actorId: actorId, actorName: actorName);

    if (blocOverride != null) {
      return BlocProvider<ActorDetailsBloc>.value(
        value: blocOverride!,
        child: body,
      );
    }

    return BlocProvider<ActorDetailsBloc>(
      create: (_) {
        final bloc = ActorDetailsBloc(
          GetIt.I<ActorDetailsUseCase>(),
          GetIt.I<AuthRepository>(),
        );
        scheduleMicrotask(
          () => bloc.add(LoadActorDetails(actorId: actorId)),
        );
        return bloc;
      },
      child: body,
    );
  }
}

class _ActorDetailsView extends StatelessWidget {
  const _ActorDetailsView({
    required this.actorId,
    this.actorName,
  });

  final int actorId;
  final String? actorName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(actorName ?? 'Actor #$actorId'),
      ),
      body: BlocBuilder<ActorDetailsBloc, ActorDetailsState>(
        builder: (context, state) {
          if (state is ActorDetailsInitial || state is ActorDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(key: Key('actorDetailsLoading')),
            );
          }

          if (state is ActorDetailsFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.exception.toString(),
                      textAlign: TextAlign.center,
                      key: const Key('actorDetailsErrorMessage'),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      key: const Key('actorDetailsRetryButton'),
                      onPressed: () {
                        context
                            .read<ActorDetailsBloc>()
                            .add(LoadActorDetails(actorId: actorId));
                      },
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ActorDetailsLoaded) {
            final details = state.actorDetails;
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                if (details.profilePath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${details.profilePath}',
                      fit: BoxFit.cover,
                      key: const Key('actorDetailsImage'),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  details.name ?? actorName ?? 'Unknown',
                  style: Theme.of(context).textTheme.headlineSmall,
                  key: const Key('actorDetailsName'),
                ),
                const SizedBox(height: 12),
                if ((details.biography ?? '').isNotEmpty)
                  Text(
                    details.biography!,
                    key: const Key('actorDetailsBiography'),
                  )
                else
                  const Text(
                    'No biography available.',
                    key: Key('actorDetailsBiographyFallback'),
                  ),
                const SizedBox(height: 12),
                if (details.knownForDepartment != null)
                  Text('Known for: ${details.knownForDepartment}'),
                if (details.birthday != null)
                  Text('Birthday: ${details.birthday}'),
                if (details.placeOfBirth != null)
                  Text('Place of birth: ${details.placeOfBirth}'),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
