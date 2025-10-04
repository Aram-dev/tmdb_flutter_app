// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchProvider _$WatchProviderFromJson(Map<String, dynamic> json) => WatchProvider(
      providerId: (json['provider_id'] as num?)?.toInt(),
      providerName: json['provider_name'] as String?,
      logoPath: json['logo_path'] as String?,
      displayPriority: (json['display_priority'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WatchProviderToJson(WatchProvider instance) =>
    <String, dynamic>{
      'provider_id': instance.providerId,
      'provider_name': instance.providerName,
      'logo_path': instance.logoPath,
      'display_priority': instance.displayPriority,
    };
