import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../common/common.dart';
import '../../../movies/presentation/widgets/movies_section.dart';
import '../../domain/usecases/discover_movies/discover_movies_use_case.dart';
import '../bloc/discover_movies/discover_movies_bloc.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _discoverMoviesBloc = DiscoverContentBloc(
    GetIt.I<DiscoverContentUseCase>(),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _discoverMoviesBloc.add(LoadDiscoverContent(category: 'movie'));

    _tabController.addListener(() {
      final category = _tabController.index == 0 ? 'movie' : 'tv';
      _discoverMoviesBloc.add(LoadDiscoverContent(category: category));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _discoverMoviesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Free To Watch',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.blueAccent,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Movies'),
              Tab(text: 'TV Shows'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: BlocBuilder<DiscoverContentBloc, MoviesState>(
              bloc: _discoverMoviesBloc,
              builder: (context, state) {
                if (state is DiscoverContentLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DiscoverContentLoaded) {
                  final movies = state.discoverMovies.results ?? [];
                  return MoviesSection(
                    title: null,
                    state: state,
                    movies: movies,
                    isExpanded: true,
                    onToggleSection: (event) => _discoverMoviesBloc.add(event),
                  );
                } else if (state is DiscoverContentLoadingFailure) {
                  return Center(child: Text(state.exception.toString()));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}