// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'now_playing_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NowPlayingEntity _$NowPlayingEntityFromJson(Map<String, dynamic> json) =>
    NowPlayingEntity(
      dates: json['dates'] == null
          ? null
          : NowPlayingDates.fromJson(json['dates'] as Map<String, dynamic>),
      page: (json['page'] as num?)?.toInt(),
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => NowPlayingResults.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: (json['total_pages'] as num?)?.toInt(),
      totalResults: (json['total_results'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NowPlayingEntityToJson(NowPlayingEntity instance) =>
    <String, dynamic>{
      'dates': instance.dates,
      'page': instance.page,
      'results': instance.results,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };
