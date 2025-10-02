import 'package:equatable/equatable.dart';

import 'actor_credit.dart';

class ActorDetails extends Equatable {
  const ActorDetails({
    required this.id,
    this.name,
    this.biography,
    this.profilePath,
    this.knownForDepartment,
    this.placeOfBirth,
    this.birthday,
    this.deathday,
    this.homepage,
    this.alsoKnownAs = const [],
    this.cast = const [],
    this.crew = const [],
  });

  final int id;
  final String? name;
  final String? biography;
  final String? profilePath;
  final String? knownForDepartment;
  final String? placeOfBirth;
  final String? birthday;
  final String? deathday;
  final String? homepage;
  final List<String> alsoKnownAs;
  final List<ActorCredit> cast;
  final List<ActorCredit> crew;

  @override
  List<Object?> get props => [
        id,
        name,
        biography,
        profilePath,
        knownForDepartment,
        placeOfBirth,
        birthday,
        deathday,
        homepage,
        alsoKnownAs,
        cast,
        crew,
      ];
}
