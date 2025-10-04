part of 'auth_cubit.dart';

enum AuthStatus {
  initial,
  loading,
  needsApiKey,
  unauthenticated,
  authenticated,
  failure,
}

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.hasApiKey = false,
    this.session,
    this.errorMessage,
  });

  final AuthStatus status;
  final bool hasApiKey;
  final AuthSession? session;
  final String? errorMessage;

  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    bool? hasApiKey,
    AuthSession? session,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool clearSession = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      hasApiKey: hasApiKey ?? this.hasApiKey,
      session: clearSession ? null : (session ?? this.session),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, hasApiKey, session, errorMessage];
}
