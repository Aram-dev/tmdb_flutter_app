import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'genre.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Genre extends Equatable {
  const Genre({
    required this.id,
    required this.name,
  });

  final int? id;
  final String? name;

  @override
  List<Object?> get props => [id, name];

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);

  Map<String, dynamic> toJson() => _$GenreToJson(this);
}
