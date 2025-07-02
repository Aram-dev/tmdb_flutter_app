part of 'trending_movies_bloc.dart';

class LoadTrendingMovies extends UiEvent {
  LoadTrendingMovies({
    this.completer, required this.selectedPeriod, required this.contentTypeId
  });
  final Completer? completer;
  final String selectedPeriod;
  final String contentTypeId;

  @override
  List<Object?> get props => [completer, selectedPeriod, contentTypeId];
}