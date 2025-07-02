import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'movies_dates_entity.dart';
import 'movie.dart';

part 'movies_entity.g.dart';

@JsonSerializable()
class MovieTvShowEntity extends Equatable {
  const MovieTvShowEntity({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final MoviesDates? dates;
  final int? page;
  final List<Movie>? results;
  @JsonKey(name: "total_pages")
  final int? totalPages;
  @JsonKey(name: "total_results")
  final int? totalResults;

  @override
  List<Object?> get props => [dates, page, results, totalPages, totalResults];
}