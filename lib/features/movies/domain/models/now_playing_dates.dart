

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'now_playing_dates.g.dart';

@JsonSerializable()
class NowPlayingDates extends Equatable {
  const NowPlayingDates({required this.maximum, required this.minimum});

  final String? maximum;
  final String? minimum;

  @override
  List<Object?> get props => [maximum, minimum];

  factory NowPlayingDates.fromJson(Map<String, dynamic> json) =>
      _$NowPlayingDatesFromJson(json);

  Map<String, dynamic> toJson() => _$NowPlayingDatesToJson(this);
}