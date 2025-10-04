import 'package:equatable/equatable.dart';

class AuthSession extends Equatable {
  const AuthSession({
    required this.sessionId,
    this.accountId,
  });

  final String sessionId;
  final int? accountId;

  @override
  List<Object?> get props => [sessionId, accountId];

  AuthSession copyWith({
    String? sessionId,
    int? accountId,
  }) {
    return AuthSession(
      sessionId: sessionId ?? this.sessionId,
      accountId: accountId ?? this.accountId,
    );
  }
}
