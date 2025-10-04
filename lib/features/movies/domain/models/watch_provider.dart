import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'watch_provider.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class WatchProvider extends Equatable {
  const WatchProvider({
    required this.providerId,
    required this.providerName,
    required this.logoPath,
    required this.displayPriority,
  });

  final int? providerId;
  final String? providerName;
  final String? logoPath;
  final int? displayPriority;

  @override
  List<Object?> get props => [providerId, providerName, logoPath, displayPriority];

  factory WatchProvider.fromJson(Map<String, dynamic> json) =>
      _$WatchProviderFromJson(json);

  Map<String, dynamic> toJson() => _$WatchProviderToJson(this);
}
