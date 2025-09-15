import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "auth_event.dart";
part "auth_state.dart";


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // TODO: call your login API
      await Future.delayed(const Duration(seconds: 2));
      emit(Authenticated(userId: "12345", email: event.email));
    } catch (e) {
      emit(AuthError("Login failed: ${e.toString()}"));
    }
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // TODO: call your signup API
      await Future.delayed(const Duration(seconds: 2));
      emit(Authenticated(userId: "67890", email: event.email));
    } catch (e) {
      emit(AuthError("Signup failed: ${e.toString()}"));
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // TODO: call your forgot password API
      await Future.delayed(const Duration(seconds: 1));
      emit(PasswordResetSent(event.email));
    } catch (e) {
      emit(AuthError("Reset password failed: ${e.toString()}"));
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    emit(Unauthenticated());
  }
}
