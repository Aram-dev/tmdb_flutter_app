import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../common/common.dart';
import '../../domain/usecases/popular/popular_actors_use_case.dart';
import '../bloc/popular_actors_bloc.dart';
import '../widgets/actor_card.dart';

@RoutePage()
class ActorsScreen extends StatefulWidget {
  const ActorsScreen({super.key});

  @override
  State<ActorsScreen> createState() => _ActorsScreenState();
}

class _ActorsScreenState extends State<ActorsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PopularActorsBloc>(
      create: (_) =>
          PopularActorsBloc(
            GetIt.I<PopularActorsUseCase>(),
          )..add(LoadPopularActors()),
      child: BlocBuilder<PopularActorsBloc, UiState>(
        builder: (context, state) {
          // Initial / first paint shimmer
          if (state is PopularActorsInitial || state is PopularActorsLoading) {
            // return const InitialShimmers();
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PopularActorsLoadingFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.exception.toString(),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => context
                          .read<PopularActorsBloc>()
                          .add(LoadPopularActors()),
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is PopularActorsLoaded) {
            final items = state.popularActors;
            final hasMore = state.hasMore;

            return NotificationListener<ScrollNotification>(
              onNotification: (n) {
                final atEnd = n.metrics.pixels >= n.metrics.maxScrollExtent - 300;
                if (atEnd && hasMore) {
                  context.read<PopularActorsBloc>().add(LoadPopularActors());
                }
                return false;
              },
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(12),
                    sliver: SliverGrid.builder(
                      itemCount: items.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,          // 3 on tablets if you wish
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: .62,     // image + two text lines
                      ),
                        itemBuilder: (context, index) {
                          final actor = items[index];
                          return TweenAnimationBuilder<double>(
                            key: ValueKey('actor-${actor.id}'),
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: Duration(milliseconds: 260 + (index % 6) * 30),
                            curve: Curves.easeOut,
                            builder: (context, t, child) {
                              final scale = 0.94 + 0.06 * t;
                              return Transform.scale(
                                scale: scale,
                                child: Opacity(opacity: t, child: child),
                              );
                            },
                            child: ActorCard(actor: actor),
                          );
                        },
                    ),
                  ),
                  // Full-width footer -> horizontally centered
                  SliverToBoxAdapter(
                    child: hasMore
                        ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        ),
                      ),
                    )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            );
          }

          // Fallback (shouldn’t normally hit)
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
