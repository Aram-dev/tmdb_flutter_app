import 'package:flutter/material.dart';
import 'package:tmdb_flutter_app/features/actors/domain/models/actors_list_result.dart';

class ActorCard extends StatelessWidget {
  const ActorCard({super.key, required this.actor});

  final ActorsListResults actor;

  @override
  Widget build(BuildContext context) {
    final imgUrl = (actor.profilePath != null && actor.profilePath!.isNotEmpty)
        ? 'https://image.tmdb.org/t/p/w300${actor.profilePath}'
        : null;

    // (Optional) short “known for”
    String knownForText = '';
    final kf = actor.knownFor ?? const [];
    if (kf.isNotEmpty) {
      final titles = kf
          .map((e) => (e.title ?? e.originalTitle) ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
      knownForText = titles.take(2).join(', ');
    }

    return GestureDetector(
      onTap: () {},
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: AspectRatio(
          aspectRatio: 3 / 4, // portrait tile
          child: Stack(
            fit: StackFit.expand,
            children: [
              // photo
              if (imgUrl != null)
                Image.network(
                  imgUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder(),
                  loadingBuilder: (c, child, p) =>
                      p == null ? child : Container(color: Colors.black12),
                  frameBuilder: (ctx, child, frame, wasSync) {
                    if (wasSync || frame != null) {
                      return AnimatedOpacity(
                        opacity: 1,
                        duration: const Duration(milliseconds: 300),
                        child: child,
                      );
                    }
                    return const SizedBox.expand(); // before first frame
                  },
                )
              else
                _placeholder(),

              // subtle bottom gradient for legibility
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
              ),

              // text overlay
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (actor.name?.isNotEmpty ?? false)
                          ? actor.name!
                          : 'Unknown',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    if (knownForText.isNotEmpty)
                      Text(
                        knownForText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    color: Colors.black12,
    child: const Center(child: Icon(Icons.person, color: Colors.white70)),
  );
}
