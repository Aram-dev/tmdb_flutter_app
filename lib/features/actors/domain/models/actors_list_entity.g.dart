// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actors_list_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActorsListEntity _$ActorsListEntityFromJson(Map<String, dynamic> json) =>
    ActorsListEntity(
      page: (json['page'] as num?)?.toInt(),
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => ActorsListResults.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: (json['total_pages'] as num?)?.toInt(),
      totalResults: (json['total_results'] as num?)?.toInt(),
      hasMore: json['hasMore'] as bool,
    );

Map<String, dynamic> _$ActorsListEntityToJson(ActorsListEntity instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
      'hasMore': instance.hasMore,
    };
