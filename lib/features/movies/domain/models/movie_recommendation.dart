import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_recommendation.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieRecommendation extends Equatable {
  const MovieRecommendation({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
  });

  final int? id;
  final String? title;
  final String? originalTitle;
  final String? posterPath;
  final String? backdropPath;
  final double? voteAverage;
  final String? releaseDate;

  @override
  List<Object?> get props => [
        id,
        title,
        originalTitle,
        posterPath,
        backdropPath,
        voteAverage,
        releaseDate,
      ];

  factory MovieRecommendation.fromJson(Map<String, dynamic> json) =>
      _$MovieRecommendationFromJson(json);

  Map<String, dynamic> toJson() => _$MovieRecommendationToJson(this);
}
