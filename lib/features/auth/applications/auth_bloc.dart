import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/features/auth/domain/usecases/change_password.dart';
import 'package:mama_kris/features/auth/domain/usecases/check_email.dart';
import 'package:mama_kris/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:mama_kris/features/auth/domain/usecases/login_applicant.dart';
import 'package:mama_kris/features/auth/domain/usecases/register_applicant.dart';
import 'package:mama_kris/features/auth/domain/usecases/validate_otp.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckEmail checkEmail;
  final ForgotPasswordUsecase forgotPassword;
  final ValidateOtp validateOtp;
  final RegisterApplicant register;
  final LoginApplicant login;
  final ChangePassword changePassword;

  AuthBloc({
    required this.checkEmail,
    required this.forgotPassword,
    required this.validateOtp,
    required this.register,
    required this.login,
    required this.changePassword,
  }) : super(AuthInitial()) {
    on<CheckEmailEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final exists = await checkEmail(event.email);
        exists.fold(
          (failure) {
            emit(CheckEmailErroState(failure.message));
          },
          (success) {
            emit(AuthEmailChecked(true));
          },
        );
      } catch (e) {
        emit(CheckEmailErroState(e.toString()));
      }
    });

    on<ForgotPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final exists = await forgotPassword(event.email);
        exists.fold(
          (failure) {
            emit(CheckEmailErroState(failure.message));
          },
          (success) {
            emit(AuthEmailChecked(true));
          },
        );
      } catch (e) {
        emit(CheckEmailErroState(e.toString()));
      }
    });

    on<ValidateOtpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final valid = await validateOtp(event.email, event.otp);

        valid.fold(
          (failure) {
            emit(AuthError(failure.message));
          },
          (success) {
            emit(AuthOtpValidated());
          },
        );
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await register(event.email, event.name, event.password, isApplicant: event.isApplicant);

        user.fold(
          (failure) {
            emit(AuthError(failure.message));
          },
          (success) {
            emit(Authenticated(success));
          },
        );
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await login(event.email, event.password);
        user.fold(
          (failure) {
            emit(AuthError(failure.message));
          },
          (success) {
            emit(Authenticated(success));
          },
        );
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<ChangePasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await changePassword(event.password);
        user.fold(
          (failure) {
            emit(AuthError(failure.message));
          },
          (success) {
            emit(Authenticated(success));
          },
        );
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
