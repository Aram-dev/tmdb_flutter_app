import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'actors_list_result_known_for.dart';

part 'actors_list_result.g.dart';

@JsonSerializable()
class ActorsListResults extends Equatable {
  const ActorsListResults({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
    required this.knownFor,
  });

  final bool? adult;
  final int? gender;
  final int? id;
  @JsonKey(name: "known_for_department")
  final String? knownForDepartment;
  final String? name;
  @JsonKey(name: "original_name")
  final String? originalName;
  final double? popularity;
  @JsonKey(name: "profile_path")
  final String? profilePath;
  @JsonKey(name: "known_for")
  final List<ActorsListResultsKnownFor>? knownFor;

  factory ActorsListResults.fromJson(Map<String, dynamic> json) =>
      _$ActorsListResultsFromJson(json);

  Map<String, dynamic> toJson() => _$ActorsListResultsToJson(this);

  @override
  List<Object?> get props => [
    adult,
    gender,
    id,
    knownForDepartment,
    name,
    originalName,
    popularity,
    profilePath,
    knownFor,
  ];
}
