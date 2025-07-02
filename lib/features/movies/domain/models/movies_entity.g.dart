// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieTvShowEntity _$MovieTvShowEntityFromJson(Map<String, dynamic> json) =>
    MovieTvShowEntity(
      dates: json['dates'] == null
          ? null
          : MoviesDates.fromJson(json['dates'] as Map<String, dynamic>),
      page: (json['page'] as num?)?.toInt(),
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: (json['total_pages'] as num?)?.toInt(),
      totalResults: (json['total_results'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MovieTvShowEntityToJson(MovieTvShowEntity instance) =>
    <String, dynamic>{
      'dates': instance.dates,
      'page': instance.page,
      'results': instance.results,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };
