import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

@RoutePage()
class ActorsScreen extends StatelessWidget {
  const ActorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Actors Screen', style: TextStyle(fontSize: 24)),
    );
  }
}