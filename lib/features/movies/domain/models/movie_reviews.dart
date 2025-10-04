import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'movie_review.dart';

part 'movie_reviews.g.dart';

@JsonSerializable(explicitToJson: true)
class MovieReviews extends Equatable {
  const MovieReviews({
    required this.id,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final int? id;
  final int? page;
  @JsonKey(defaultValue: <MovieReview>[])
  final List<MovieReview> results;
  final int? totalPages;
  final int? totalResults;

  @override
  List<Object?> get props => [
        id,
        page,
        results,
        totalPages,
        totalResults,
      ];

  factory MovieReviews.fromJson(Map<String, dynamic> json) =>
      _$MovieReviewsFromJson(json);

  Map<String, dynamic> toJson() => _$MovieReviewsToJson(this);
}
