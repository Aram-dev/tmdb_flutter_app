import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'now_playing_dates.dart';
import 'now_playing_results.dart';

part 'now_playing_entity.g.dart';

@JsonSerializable()
class NowPlayingEntity extends Equatable {
  const NowPlayingEntity({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final NowPlayingDates? dates;
  final int? page;
  final List<NowPlayingResults>? results;
  @JsonKey(name: "total_pages")
  final int? totalPages;
  @JsonKey(name: "total_results")
  final int? totalResults;

  @override
  List<Object?> get props => [dates, page, results, totalPages, totalResults];
}