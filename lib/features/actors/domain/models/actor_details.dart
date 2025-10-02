import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'actor_details.g.dart';

@JsonSerializable(explicitToJson: true)
class ActorDetails extends Equatable {
  const ActorDetails({
    this.adult,
    this.alsoKnownAs,
    this.biography,
    this.birthday,
    this.combinedCredits,
    this.deathday,
    this.gender,
    this.homepage,
    required this.id,
    this.imdbId,
    this.knownForDepartment,
    this.name,
    this.placeOfBirth,
    this.popularity,
    this.profilePath,
  });

  final bool? adult;
  @JsonKey(name: 'also_known_as')
  final List<String>? alsoKnownAs;
  final String? biography;
  final String? birthday;
  @JsonKey(name: 'combined_credits')
  final CombinedCredits? combinedCredits;
  final String? deathday;
  final int? gender;
  final String? homepage;
  final int id;
  @JsonKey(name: 'imdb_id')
  final String? imdbId;
  @JsonKey(name: 'known_for_department')
  final String? knownForDepartment;
  final String? name;
  @JsonKey(name: 'place_of_birth')
  final String? placeOfBirth;
  final double? popularity;
  @JsonKey(name: 'profile_path')
  final String? profilePath;

  @override
  List<Object?> get props => [
        adult,
        alsoKnownAs,
        biography,
        birthday,
        combinedCredits,
        deathday,
        gender,
        homepage,
        id,
        imdbId,
        knownForDepartment,
        name,
        placeOfBirth,
        popularity,
        profilePath,
      ];

  factory ActorDetails.fromJson(Map<String, dynamic> json) =>
      _$ActorDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ActorDetailsToJson(this);
}

@JsonSerializable()
class CombinedCredits extends Equatable {
  const CombinedCredits({
    this.cast = const [],
    this.crew = const [],
  });

  @JsonKey(defaultValue: [])
  final List<ActorCastCredit> cast;
  @JsonKey(defaultValue: [])
  final List<ActorCrewCredit> crew;

  @override
  List<Object?> get props => [cast, crew];

  factory CombinedCredits.fromJson(Map<String, dynamic> json) =>
      _$CombinedCreditsFromJson(json);

  Map<String, dynamic> toJson() => _$CombinedCreditsToJson(this);
}

@JsonSerializable()
class ActorCastCredit extends Equatable {
  const ActorCastCredit({
    this.adult,
    this.backdropPath,
    this.character,
    this.creditId,
    this.episodeCount,
    this.firstAirDate,
    this.genreIds,
    this.id,
    this.mediaType,
    this.name,
    this.originCountry,
    this.originalLanguage,
    this.originalName,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
    this.order,
  });

  final bool? adult;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  final String? character;
  @JsonKey(name: 'credit_id')
  final String? creditId;
  @JsonKey(name: 'episode_count')
  final int? episodeCount;
  @JsonKey(name: 'first_air_date')
  final String? firstAirDate;
  @JsonKey(name: 'genre_ids')
  final List<int>? genreIds;
  final int? id;
  @JsonKey(name: 'media_type')
  final String? mediaType;
  final String? name;
  @JsonKey(name: 'origin_country')
  final List<String>? originCountry;
  @JsonKey(name: 'original_language')
  final String? originalLanguage;
  @JsonKey(name: 'original_name')
  final String? originalName;
  @JsonKey(name: 'original_title')
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  final String? title;
  final bool? video;
  @JsonKey(name: 'vote_average')
  final double? voteAverage;
  @JsonKey(name: 'vote_count')
  final int? voteCount;
  final int? order;

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        character,
        creditId,
        episodeCount,
        firstAirDate,
        genreIds,
        id,
        mediaType,
        name,
        originCountry,
        originalLanguage,
        originalName,
        originalTitle,
        overview,
        popularity,
        posterPath,
        releaseDate,
        title,
        video,
        voteAverage,
        voteCount,
        order,
      ];

  factory ActorCastCredit.fromJson(Map<String, dynamic> json) =>
      _$ActorCastCreditFromJson(json);

  Map<String, dynamic> toJson() => _$ActorCastCreditToJson(this);
}

@JsonSerializable()
class ActorCrewCredit extends Equatable {
  const ActorCrewCredit({
    this.adult,
    this.backdropPath,
    this.creditId,
    this.department,
    this.episodeCount,
    this.firstAirDate,
    this.genreIds,
    this.id,
    this.job,
    this.mediaType,
    this.name,
    this.originCountry,
    this.originalLanguage,
    this.originalName,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  final bool? adult;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @JsonKey(name: 'credit_id')
  final String? creditId;
  final String? department;
  @JsonKey(name: 'episode_count')
  final int? episodeCount;
  @JsonKey(name: 'first_air_date')
  final String? firstAirDate;
  @JsonKey(name: 'genre_ids')
  final List<int>? genreIds;
  final int? id;
  final String? job;
  @JsonKey(name: 'media_type')
  final String? mediaType;
  final String? name;
  @JsonKey(name: 'origin_country')
  final List<String>? originCountry;
  @JsonKey(name: 'original_language')
  final String? originalLanguage;
  @JsonKey(name: 'original_name')
  final String? originalName;
  @JsonKey(name: 'original_title')
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  final String? title;
  final bool? video;
  @JsonKey(name: 'vote_average')
  final double? voteAverage;
  @JsonKey(name: 'vote_count')
  final int? voteCount;

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        creditId,
        department,
        episodeCount,
        firstAirDate,
        genreIds,
        id,
        job,
        mediaType,
        name,
        originCountry,
        originalLanguage,
        originalName,
        originalTitle,
        overview,
        popularity,
        posterPath,
        releaseDate,
        title,
        video,
        voteAverage,
        voteCount,
      ];

  factory ActorCrewCredit.fromJson(Map<String, dynamic> json) =>
      _$ActorCrewCreditFromJson(json);

  Map<String, dynamic> toJson() => _$ActorCrewCreditToJson(this);
}
