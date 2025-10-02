import 'package:equatable/equatable.dart';

class ActorDetails extends Equatable {
  const ActorDetails({
    required this.id,
    this.name,
    this.biography,
    this.profilePath,
    this.knownForDepartment,
    this.birthday,
    this.placeOfBirth,
    this.popularity,
    this.homepage,
    this.alsoKnownAs = const [],
  });

  factory ActorDetails.fromJson(Map<String, dynamic> json) {
    return ActorDetails(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String?,
      biography: json['biography'] as String?,
      profilePath: json['profile_path'] as String?,
      knownForDepartment: json['known_for_department'] as String?,
      birthday: json['birthday'] as String?,
      placeOfBirth: json['place_of_birth'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      homepage: json['homepage'] as String?,
      alsoKnownAs: (json['also_known_as'] as List?)
              ?.whereType<String>()
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'biography': biography,
      'profile_path': profilePath,
      'known_for_department': knownForDepartment,
      'birthday': birthday,
      'place_of_birth': placeOfBirth,
      'popularity': popularity,
      'homepage': homepage,
      'also_known_as': alsoKnownAs,
    };
  }

  final int id;
  final String? name;
  final String? biography;
  final String? profilePath;
  final String? knownForDepartment;
  final String? birthday;
  final String? placeOfBirth;
  final double? popularity;
  final String? homepage;
  final List<String> alsoKnownAs;

  @override
  List<Object?> get props => [
        id,
        name,
        biography,
        profilePath,
        knownForDepartment,
        birthday,
        placeOfBirth,
        popularity,
        homepage,
        alsoKnownAs,
      ];
}
