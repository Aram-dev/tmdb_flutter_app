import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_flutter_app/core/router/router.gr.dart';

import '../../domain/models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie? movie;

  const MovieCard({super.key, required this.movie});

  double _round(double value, int places) {
    final mod = pow(10.0, places);
    return ((value * mod).roundToDouble() / mod);
  }

  @override
  Widget build(BuildContext context) {
    final posterUrl = movie?.posterPath != null
        ? 'https://image.tmdb.org/t/p/w200/${movie!.posterPath}'
        : null;

    final rating = movie?.voteAverage != null
        ? _round(movie!.voteAverage!, 1).toString()
        : '0.0';

    final year = movie?.releaseDate?.substring(0, 4) ?? '——';

    return GestureDetector(
      onTap: () {
        if (movie != null) {
          context.router.push(MovieDetailsRoute(movie: movie!));
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Card(
          elevation: 2,
          color: Colors.brown,
          // margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: 120,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (posterUrl != null)
                  AspectRatio(
                    aspectRatio: 2 / 3,
                    // Common movie poster ratio (width:height)
                    child: Image.network(
                      posterUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 40),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie?.title ?? 'Untitled',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            year,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
