part of 'trending_tv_shows_bloc.dart';

class LoadTrendingTvShows extends UiEvent {
  LoadTrendingTvShows({
    this.completer, required this.selectedPeriod
  });
  final Completer? completer;
  final String selectedPeriod;

  @override
  List<Object?> get props => [completer, selectedPeriod];
}