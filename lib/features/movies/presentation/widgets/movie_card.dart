import 'package:flutter/material.dart';

import '../../domain/models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie? movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   // Navigate to details screen with the selected movie
      //   context.router.push(MovieDetailsRoute(movie: movie));
      // },
      child: SizedBox(
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie poster image
            Image.network(
              'https://image.tmdb.org/t/p/w200/${movie?.posterPath ?? ''}',
              width: 100,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 4),
            // Movie title (single line)
            Text(
              movie?.title ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            // Year and rating
            Text(
              "${movie?.releaseDate} • ${movie?.voteAverage}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}