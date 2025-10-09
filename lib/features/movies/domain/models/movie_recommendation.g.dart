// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieRecommendation _$MovieRecommendationFromJson(Map<String, dynamic> json) =>
    MovieRecommendation(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      originalTitle: json['original_title'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      releaseDate: json['release_date'] as String?,
    );

Map<String, dynamic> _$MovieRecommendationToJson(
        MovieRecommendation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'original_title': instance.originalTitle,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'vote_average': instance.voteAverage,
      'release_date': instance.releaseDate,
    };
