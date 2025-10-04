// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_recommendations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieRecommendations _$MovieRecommendationsFromJson(
        Map<String, dynamic> json) =>
    MovieRecommendations(
      page: (json['page'] as num?)?.toInt(),
      results: (json['results'] as List<dynamic>?)
              ?.map((e) =>
                  MovieRecommendation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MovieRecommendation>[],
      totalPages: (json['total_pages'] as num?)?.toInt(),
      totalResults: (json['total_results'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MovieRecommendationsToJson(
        MovieRecommendations instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results.map((e) => e.toJson()).toList(),
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };
