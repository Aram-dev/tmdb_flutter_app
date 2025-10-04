// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieReview _$MovieReviewFromJson(Map<String, dynamic> json) => MovieReview(
      id: json['id'] as String?,
      author: json['author'] as String?,
      authorDetails: json['author_details'] as Map<String, dynamic>?,
      content: json['content'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      url: json['url'] as String?,
    );

Map<String, dynamic> _$MovieReviewToJson(MovieReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'author_details': instance.authorDetails,
      'content': instance.content,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'url': instance.url,
    };
