import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'watch_provider.dart';

part 'movie_watch_providers.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class MovieWatchProviders extends Equatable {
  const MovieWatchProviders({
    required this.link,
    required this.flatrate,
    required this.rent,
    required this.buy,
    required this.ads,
    required this.free,
  });

  const MovieWatchProviders.empty()
      : link = null,
        flatrate = const [],
        rent = const [],
        buy = const [],
        ads = const [],
        free = const [];

  final String? link;
  @JsonKey(defaultValue: <WatchProvider>[])
  final List<WatchProvider> flatrate;
  @JsonKey(defaultValue: <WatchProvider>[])
  final List<WatchProvider> rent;
  @JsonKey(defaultValue: <WatchProvider>[])
  final List<WatchProvider> buy;
  @JsonKey(defaultValue: <WatchProvider>[])
  final List<WatchProvider> ads;
  @JsonKey(defaultValue: <WatchProvider>[])
  final List<WatchProvider> free;

  bool get hasAnyProviders =>
      flatrate.isNotEmpty ||
      rent.isNotEmpty ||
      buy.isNotEmpty ||
      ads.isNotEmpty ||
      free.isNotEmpty;

  @override
  List<Object?> get props => [link, flatrate, rent, buy, ads, free];

  factory MovieWatchProviders.fromJson(Map<String, dynamic> json) =>
      _$MovieWatchProvidersFromJson(json);

  Map<String, dynamic> toJson() => _$MovieWatchProvidersToJson(this);
}
