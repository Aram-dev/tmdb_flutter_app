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
    this.apiKey,
    this.session,
    this.errorMessage,
  });

  final AuthStatus status;
  final String? apiKey;
  final AuthSession? session;
  final String? errorMessage;

  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    String? apiKey,
    AuthSession? session,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool clearSession = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      apiKey: apiKey ?? this.apiKey,
      session: clearSession ? null : (session ?? this.session),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, apiKey, session, errorMessage];
}
