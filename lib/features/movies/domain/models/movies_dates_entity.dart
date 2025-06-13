

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movies_dates_entity.g.dart';

@JsonSerializable()
class MoviesDates extends Equatable {
  const MoviesDates({required this.maximum, required this.minimum});

  final String? maximum;
  final String? minimum;

  @override
  List<Object?> get props => [maximum, minimum];

  factory MoviesDates.fromJson(Map<String, dynamic> json) =>
      _$MoviesDatesFromJson(json);

  Map<String, dynamic> toJson() => _$MoviesDatesToJson(this);
}