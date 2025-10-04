import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/exceptions/auth_exception.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required AuthRepository authRepository,
    Talker? talker,
  })  : _authRepository = authRepository,
        _talker = talker,
        super(const AuthState());

  final AuthRepository _authRepository;
  final Talker? _talker;

  Future<void> bootstrap() async {
    emit(state.copyWith(status: AuthStatus.loading, clearErrorMessage: true));
    try {
      final apiKey = await _authRepository.getApiKey();
      final session = await _authRepository.getSession();

      if (apiKey == null || apiKey.isEmpty) {
        emit(const AuthState(status: AuthStatus.needsApiKey));
        return;
      }

      if (session != null) {
        emit(AuthState(
          status: AuthStatus.authenticated,
          apiKey: apiKey,
          session: session,
        ));
        return;
      }

      emit(AuthState(status: AuthStatus.unauthenticated, apiKey: apiKey));
    } catch (error, stackTrace) {
      _logError(error, stackTrace);
      emit(AuthState(
        status: AuthStatus.failure,
        errorMessage: _describeError(error),
      ));
    }
  }

  Future<void> registerApiKey(String apiKey) async {
    emit(state.copyWith(status: AuthStatus.loading, clearErrorMessage: true));
    try {
      final isValid = await _authRepository.validateApiKey(apiKey);
      if (!isValid) {
        throw AuthException('The provided TMDB API key is invalid.');
      }
      await _authRepository.saveApiKey(apiKey);
      emit(AuthState(status: AuthStatus.unauthenticated, apiKey: apiKey));
    } catch (error, stackTrace) {
      _logError(error, stackTrace);
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: _describeError(error),
      ));
    }
  }

  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, clearErrorMessage: true));
    try {
      final apiKey = await _authRepository.requireApiKey();
      final session = await _authRepository.createSession(
        apiKey: apiKey,
        username: username,
        password: password,
      );
      emit(AuthState(
        status: AuthStatus.authenticated,
        apiKey: apiKey,
        session: session,
      ));
    } catch (error, stackTrace) {
      _logError(error, stackTrace);
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: _describeError(error),
      ));
    }
  }

  Future<void> signOut() async {
    emit(state.copyWith(status: AuthStatus.loading, clearErrorMessage: true));
    try {
      final apiKey = await _authRepository.getApiKey();
      await _authRepository.clearSession();
      if (apiKey == null || apiKey.isEmpty) {
        emit(const AuthState(status: AuthStatus.needsApiKey));
      } else {
        emit(AuthState(status: AuthStatus.unauthenticated, apiKey: apiKey));
      }
    } catch (error, stackTrace) {
      _logError(error, stackTrace);
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: _describeError(error),
      ));
    }
  }

  Future<void> clearAll() async {
    emit(state.copyWith(status: AuthStatus.loading, clearErrorMessage: true, clearSession: true));
    try {
      await _authRepository.clearSession();
      await _authRepository.clearApiKey();
      emit(const AuthState(status: AuthStatus.needsApiKey));
    } catch (error, stackTrace) {
      _logError(error, stackTrace);
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: _describeError(error),
      ));
    }
  }

  void resetError() {
    if (state.errorMessage != null) {
      emit(state.copyWith(clearErrorMessage: true));
    }
  }

  String _describeError(Object error) {
    if (error is AuthException) {
      return error.message;
    }
    return 'Authentication failed. Please try again.';
  }

  void _logError(Object error, StackTrace stackTrace) {
    _talker?.handle(error, stackTrace);
  }
}
