// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_credits.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieCredits _$MovieCreditsFromJson(Map<String, dynamic> json) => MovieCredits(
      id: (json['id'] as num?)?.toInt(),
      cast: (json['cast'] as List<dynamic>?)
              ?.map((e) => MovieCredit.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      crew: (json['crew'] as List<dynamic>?)
              ?.map((e) => MovieCredit.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$MovieCreditsToJson(MovieCredits instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cast': instance.cast.map((e) => e.toJson()).toList(),
      'crew': instance.crew.map((e) => e.toJson()).toList(),
    };
