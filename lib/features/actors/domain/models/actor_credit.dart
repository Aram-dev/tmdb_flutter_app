import 'package:equatable/equatable.dart';

class ActorCredit extends Equatable {
  const ActorCredit({
    this.creditId,
    this.id,
    this.title,
    this.originalTitle,
    this.mediaType,
    this.character,
    this.job,
    this.posterPath,
    this.releaseDate,
    this.voteAverage,
  });

  final String? creditId;
  final int? id;
  final String? title;
  final String? originalTitle;
  final String? mediaType;
  final String? character;
  final String? job;
  final String? posterPath;
  final String? releaseDate;
  final double? voteAverage;

  String? get displayTitle => title?.isNotEmpty == true
      ? title
      : originalTitle?.isNotEmpty == true
          ? originalTitle
          : null;

  @override
  List<Object?> get props => [
        creditId,
        id,
        title,
        originalTitle,
        mediaType,
        character,
        job,
        posterPath,
        releaseDate,
        voteAverage,
      ];
}
