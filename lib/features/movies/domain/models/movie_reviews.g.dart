// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_reviews.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieReviews _$MovieReviewsFromJson(Map<String, dynamic> json) => MovieReviews(
      id: (json['id'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => MovieReview.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalPages: (json['totalPages'] as num?)?.toInt(),
      totalResults: (json['totalResults'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MovieReviewsToJson(MovieReviews instance) =>
    <String, dynamic>{
      'id': instance.id,
      'page': instance.page,
      'results': instance.results.map((e) => e.toJson()).toList(),
      'totalPages': instance.totalPages,
      'totalResults': instance.totalResults,
    };
