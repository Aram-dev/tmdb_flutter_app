part of 'popular_actors_bloc.dart';

class PopularActorsInitial extends UiState {
  @override
  List<Object?> get props => [];
}

class PopularActorsLoading extends UiState {
  @override
  List<Object?> get props => [];
}

class PopularActorsLoaded extends UiState {
  PopularActorsLoaded({
    required this.page,
    required this.hasMore,
    required this.popularActors,
  });

  final int page; // last loaded page
  final bool hasMore; // can we load more?
  final List<ActorsListResults> popularActors;

  @override
  List<Object?> get props => [page, hasMore, popularActors];
}

class PopularActorsLoadingFailure extends UiState {
  PopularActorsLoadingFailure({required this.exception});

  final Object? exception;

  @override
  List<Object?> get props => [exception];
}
