import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

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

@JsonSerializable()
class NowPlayingDates extends Equatable {
  const NowPlayingDates({required this.maximum, required this.minimum});

  final String? maximum;
  final String? minimum;

  @override
  List<Object?> get props => [maximum, minimum];
}

@JsonSerializable()
class NowPlayingResults extends Equatable {
  const NowPlayingResults({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  final bool? adult;
  @JsonKey(name: "backdrop_path")
  final String? backdropPath;
  @JsonKey(name: "genre_ids")
  final List<int>? genreIds;
  final int? id;
  @JsonKey(name: "original_language")
  final String? originalLanguage;
  @JsonKey(name: "original_title")
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  @JsonKey(name: "poster_path")
  final String? posterPath;
  @JsonKey(name: "release_date")
  final String? releaseDate;
  final String? title;
  final bool? video;
  @JsonKey(name: "vote_average")
  final double? voteAverage;
  @JsonKey(name: "vote_count")
  final int? voteCount;

  @override
  List<Object?> get props => [
    adult,
    backdropPath,
    genreIds,
    id,
    originalLanguage,
    originalTitle,
    overview,
    popularity,
    posterPath,
    releaseDate,
    title,
    video,
    voteAverage,
    voteCount,
  ];
}
