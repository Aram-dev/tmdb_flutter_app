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
          [],
      totalPages: (json['totalPages'] as num?)?.toInt(),
      totalResults: (json['totalResults'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MovieRecommendationsToJson(
        MovieRecommendations instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results.map((e) => e.toJson()).toList(),
      'totalPages': instance.totalPages,
      'totalResults': instance.totalResults,
    };
