import 'dart:async';

import 'package:equatable/equatable.dart';

abstract class UiEvent extends Equatable {}

abstract class UiState extends Equatable {}

class ConnectionFailure extends UiState {
  ConnectionFailure({
    required this.exception
  });
  final Object? exception;

  @override
  List<Object?> get props => [exception];

}

class ToggleSection extends UiEvent {
  ToggleSection({
    this.completer
  });
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}