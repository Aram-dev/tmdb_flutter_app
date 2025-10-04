import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'genre.dart';

part 'movie_detail.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MovieDetail extends Equatable {
  const MovieDetail({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.tagline,
    required this.runtime,
    required this.releaseDate,
    required this.status,
    required this.backdropPath,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.genres,
    required this.homepage,
    required this.originalLanguage,
    required this.popularity,
  });

  final int? id;
  final String? title;
  final String? originalTitle;
  final String? overview;
  final String? tagline;
  final int? runtime;
  final String? releaseDate;
  final String? status;
  final String? backdropPath;
  final String? posterPath;
  final double? voteAverage;
  final int? voteCount;
  @JsonKey(defaultValue: <Genre>[])
  final List<Genre> genres;
  final String? homepage;
  final String? originalLanguage;
  final double? popularity;

  @override
  List<Object?> get props => [
        id,
        title,
        originalTitle,
        overview,
        tagline,
        runtime,
        releaseDate,
        status,
        backdropPath,
        posterPath,
        voteAverage,
        voteCount,
        genres,
        homepage,
        originalLanguage,
        popularity,
      ];

  factory MovieDetail.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailToJson(this);
}
