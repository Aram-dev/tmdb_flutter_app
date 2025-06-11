import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:tmdb_flutter_app/features/movies/domain/usecases/now_playing_movies_use_case.dart';
import 'package:tmdb_flutter_app/features/movies/presentation/bloc/now_playing_movies_bloc.dart';

@RoutePage()
class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final _cryptoListBloc = NowPlayingMoviesBloc(
    GetIt.I<NowPlayingMoviesUseCase>(),
  );

  @override
  void initState() {
    _cryptoListBloc.add(LoadNowPlayingMovies());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TalkerScreen(talker: GetIt.I<Talker>()),
                ),
              );
            },
            icon: Icon(Icons.document_scanner_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        child: BlocBuilder<NowPlayingMoviesBloc, NowPlayingMoviesState>(
          bloc: _cryptoListBloc,
          builder: (context, state) {
            if (state is NowPlayingMoviesLoaded) {

            }
            if (state is NowPlayingMoviesLoadingFailure) {

            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
        onRefresh: () async {
          final completer = Completer();
          _cryptoListBloc.add(LoadNowPlayingMovies(completer: completer));
          return completer.future;
        },
      ),
    );
  }
}