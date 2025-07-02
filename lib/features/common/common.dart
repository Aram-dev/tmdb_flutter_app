import 'dart:async';

import 'package:equatable/equatable.dart';

abstract class UiEvent extends Equatable {}

abstract class UiState extends Equatable {}

class ToggleSection extends UiEvent {
  ToggleSection({
    this.completer
  });
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}