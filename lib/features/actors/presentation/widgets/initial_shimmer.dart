import 'package:flutter/material.dart';
import 'package:tmdb_flutter_app/features/actors/presentation/widgets/shimmer_card.dart';

class InitialShimmers extends StatelessWidget {
  const InitialShimmers({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // basic while loading
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3 / 4,
      ),
      itemCount: 6,
      itemBuilder: (_, _) => ShimmerCard(),
    );
  }
}