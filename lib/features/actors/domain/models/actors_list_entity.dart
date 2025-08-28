import 'package:json_annotation/json_annotation.dart' ;
import 'package:equatable/equatable.dart';

import 'actors_list_result.dart';

part 'actors_list_entity.g.dart';

@JsonSerializable()
class ActorsListEntity extends Equatable {
  const ActorsListEntity({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
    required this.hasMore,
  });

  final int? page;
  final List<ActorsListResults>? results;
  @JsonKey(name: "total_pages")
  final int? totalPages;
  @JsonKey(name: "total_results")
  final int? totalResults;
  final bool hasMore;

  @override
  List<Object?> get props => [page, results, totalPages, totalResults, hasMore];

  factory ActorsListEntity.fromJson(Map<String, dynamic> json)
  => _$ActorsListEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ActorsListEntityToJson(this);
}