// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetail _$MovieDetailFromJson(Map<String, dynamic> json) => MovieDetail(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      originalTitle: json['original_title'] as String?,
      overview: json['overview'] as String?,
      tagline: json['tagline'] as String?,
      runtime: (json['runtime'] as num?)?.toInt(),
      releaseDate: json['release_date'] as String?,
      status: json['status'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      posterPath: json['poster_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: (json['vote_count'] as num?)?.toInt(),
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Genre>[],
      homepage: json['homepage'] as String?,
      originalLanguage: json['original_language'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MovieDetailToJson(MovieDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'tagline': instance.tagline,
      'runtime': instance.runtime,
      'release_date': instance.releaseDate,
      'status': instance.status,
      'backdrop_path': instance.backdropPath,
      'poster_path': instance.posterPath,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'genres': instance.genres.map((e) => e.toJson()).toList(),
      'homepage': instance.homepage,
      'original_language': instance.originalLanguage,
      'popularity': instance.popularity,
    };
