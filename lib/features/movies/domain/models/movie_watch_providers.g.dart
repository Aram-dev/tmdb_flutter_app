// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_watch_providers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieWatchProviders _$MovieWatchProvidersFromJson(Map<String, dynamic> json) =>
    MovieWatchProviders(
      link: json['link'] as String?,
      flatrate: (json['flatrate'] as List<dynamic>?)
              ?.map((e) => WatchProvider.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rent: (json['rent'] as List<dynamic>?)
              ?.map((e) => WatchProvider.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      buy: (json['buy'] as List<dynamic>?)
              ?.map((e) => WatchProvider.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      ads: (json['ads'] as List<dynamic>?)
              ?.map((e) => WatchProvider.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      free: (json['free'] as List<dynamic>?)
              ?.map((e) => WatchProvider.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$MovieWatchProvidersToJson(
        MovieWatchProviders instance) =>
    <String, dynamic>{
      'link': instance.link,
      'flatrate': instance.flatrate.map((e) => e.toJson()).toList(),
      'rent': instance.rent.map((e) => e.toJson()).toList(),
      'buy': instance.buy.map((e) => e.toJson()).toList(),
      'ads': instance.ads.map((e) => e.toJson()).toList(),
      'free': instance.free.map((e) => e.toJson()).toList(),
    };
