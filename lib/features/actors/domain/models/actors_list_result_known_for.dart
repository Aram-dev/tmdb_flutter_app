import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'actors_list_result_known_for.g.dart';

@JsonSerializable()
class ActorsListResultsKnownFor extends Equatable {
  const ActorsListResultsKnownFor({
    required this.adult,
    required this.backdropPath,
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.mediaType,
    required this.originalLanguage,
    required this.genreIds,
    required this.popularity,
    required this.releaseDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  final bool? adult;
  @JsonKey(name: "backdrop_path")
  final String? backdropPath;
  final int? id;
  final String? title;
  @JsonKey(name: "original_title")
  final String? originalTitle;
  final String? overview;
  @JsonKey(name: "poster_path")
  final String? posterPath;
  @JsonKey(name: "media_type")
  final String? mediaType;
  @JsonKey(name: "original_language")
  final String? originalLanguage;
  @JsonKey(name: "genre_ids")
  final List<int>? genreIds;
  final double? popularity;
  @JsonKey(name: "release_date")
  final String? releaseDate;
  final bool? video;
  @JsonKey(name: "vote_average")
  final double? voteAverage;
  @JsonKey(name: "vote_count")
  final int? voteCount;

  factory ActorsListResultsKnownFor.fromJson(Map<String, dynamic> json) =>
      _$ActorsListResultsKnownForFromJson(json);

  Map<String, dynamic> toJson() => _$ActorsListResultsKnownForToJson(this);

  @override
  List<Object?> get props => [
    adult,
    backdropPath,
    id,
    title,
    originalTitle,
    overview,
    posterPath,
    mediaType,
    originalLanguage,
    genreIds,
    popularity,
    releaseDate,
    video,
    voteAverage,
    voteCount,
  ];
}
