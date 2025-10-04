import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_credit.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieCredit extends Equatable {
  const MovieCredit({
    required this.creditId,
    required this.id,
    required this.name,
    required this.originalName,
    required this.profilePath,
    required this.character,
    required this.job,
    required this.department,
    required this.knownForDepartment,
    required this.order,
  });

  final String? creditId;
  final int? id;
  final String? name;
  final String? originalName;
  final String? profilePath;
  final String? character;
  final String? job;
  final String? department;
  final String? knownForDepartment;
  final int? order;

  bool get isCast => character != null && character!.isNotEmpty;

  String? get role => character?.isNotEmpty == true ? character : job;

  @override
  List<Object?> get props => [
        creditId,
        id,
        name,
        originalName,
        profilePath,
        character,
        job,
        department,
        knownForDepartment,
        order,
      ];

  factory MovieCredit.fromJson(Map<String, dynamic> json) =>
      _$MovieCreditFromJson(json);

  Map<String, dynamic> toJson() => _$MovieCreditToJson(this);
}
