import 'dart:async';

import 'package:equatable/equatable.dart';

abstract class MoviesEvent extends Equatable {}

abstract class MoviesState extends Equatable {}

class ToggleSection extends MoviesEvent {
  ToggleSection({
    this.completer
  });
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}