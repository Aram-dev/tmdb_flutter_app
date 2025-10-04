import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'movie_credit.dart';

part 'movie_credits.g.dart';

@JsonSerializable(explicitToJson: true)
class MovieCredits extends Equatable {
  const MovieCredits({
    required this.id,
    required this.cast,
    required this.crew,
  });

  final int? id;
  @JsonKey(defaultValue: <MovieCredit>[])
  final List<MovieCredit> cast;
  @JsonKey(defaultValue: <MovieCredit>[])
  final List<MovieCredit> crew;

  @override
  List<Object?> get props => [id, cast, crew];

  factory MovieCredits.fromJson(Map<String, dynamic> json) =>
      _$MovieCreditsFromJson(json);

  Map<String, dynamic> toJson() => _$MovieCreditsToJson(this);
}
