part of 'discover_movies_bloc.dart';

class LoadDiscoverContent extends MoviesEvent {
  LoadDiscoverContent({
    this.completer,
    required this.category
  });
  final Completer? completer;
  final String category;

  @override
  List<Object?> get props => [completer, category];
}

class ToggleDiscoverSection extends MoviesEvent {
  ToggleDiscoverSection({
    this.completer
  });
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}