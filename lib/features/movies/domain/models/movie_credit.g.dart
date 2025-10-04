// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_credit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieCredit _$MovieCreditFromJson(Map<String, dynamic> json) => MovieCredit(
      creditId: json['credit_id'] as String?,
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      originalName: json['original_name'] as String?,
      profilePath: json['profile_path'] as String?,
      character: json['character'] as String?,
      job: json['job'] as String?,
      department: json['department'] as String?,
      knownForDepartment: json['known_for_department'] as String?,
      order: (json['order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MovieCreditToJson(MovieCredit instance) =>
    <String, dynamic>{
      'credit_id': instance.creditId,
      'id': instance.id,
      'name': instance.name,
      'original_name': instance.originalName,
      'profile_path': instance.profilePath,
      'character': instance.character,
      'job': instance.job,
      'department': instance.department,
      'known_for_department': instance.knownForDepartment,
      'order': instance.order,
    };
