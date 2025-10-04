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
          const <MovieReview>[],
      totalPages: (json['total_pages'] as num?)?.toInt(),
      totalResults: (json['total_results'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MovieReviewsToJson(MovieReviews instance) =>
    <String, dynamic>{
      'id': instance.id,
      'page': instance.page,
      'results': instance.results.map((e) => e.toJson()).toList(),
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };
