import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_review.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieReview extends Equatable {
  const MovieReview({
    required this.id,
    required this.author,
    required this.authorDetails,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.url,
  });

  final String? id;
  final String? author;
  final Map<String, dynamic>? authorDetails;
  final String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? url;

  @override
  List<Object?> get props => [
        id,
        author,
        authorDetails,
        content,
        createdAt,
        updatedAt,
        url,
      ];

  factory MovieReview.fromJson(Map<String, dynamic> json) =>
      _$MovieReviewFromJson(json);

  Map<String, dynamic> toJson() => _$MovieReviewToJson(this);
}
