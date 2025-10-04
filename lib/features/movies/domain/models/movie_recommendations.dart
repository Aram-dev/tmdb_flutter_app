import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'movie_recommendation.dart';

part 'movie_recommendations.g.dart';

@JsonSerializable(explicitToJson: true)
class MovieRecommendations extends Equatable {
  const MovieRecommendations({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final int? page;
  @JsonKey(defaultValue: <MovieRecommendation>[])
  final List<MovieRecommendation> results;
  final int? totalPages;
  final int? totalResults;

  @override
  List<Object?> get props => [page, results, totalPages, totalResults];

  factory MovieRecommendations.fromJson(Map<String, dynamic> json) =>
      _$MovieRecommendationsFromJson(json);

  Map<String, dynamic> toJson() => _$MovieRecommendationsToJson(this);
}
