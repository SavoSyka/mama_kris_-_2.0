import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mama_kris/features/emp/emp_auth/application/bloc/emp_auth_event.dart';
import 'package:mama_kris/features/emp/emp_auth/application/bloc/emp_auth_state.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/usecases/emp_check_email_usecase.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/usecases/emp_forgot_password_usecase.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/usecases/emp_login_usecase.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/usecases/emp_login_using_cached_usecase.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/usecases/emp_login_with_apple_usecase.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/usecases/emp_login_with_google_usecase.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/usecases/emp_resend_otp_usecase.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/usecases/emp_signup_usecase.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/usecases/emp_update_password_usecase.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/usecases/emp_verify_otp_usecase.dart';

class EmpAuthBloc extends Bloc<EmpAuthEvent, EmpAuthState> {
  final EmpLoginUsecase loginUsecase;
  final EmpSignupUsecase signupUsecase;
  final EmpCheckEmailUsecase checkEmailUsecase;

  final EmpVerifyOtpUsecase verifyOtpUsecase;
  final EmpResendOtpUsecase resendOtpUsecase;
  final EmpForgotPasswordUsecase forgotPasswordUsecase;
  final EmpLoginWithGoogleUsecase loginWithGoogleUsecase;
  final EmpUpdatePasswordUsecase updatePasswordUsecase;
  final EmpLoginWithAppleUsecase loginWithAppleUsecase;
  final EmpLoginUsingCachedUsecase empLoginUsingCachedUsecase;

  EmpAuthBloc({
    required this.loginUsecase,
    required this.signupUsecase,
    required this.checkEmailUsecase,

    required this.verifyOtpUsecase,
    required this.resendOtpUsecase,
    required this.forgotPasswordUsecase,
    required this.loginWithGoogleUsecase,
    required this.updatePasswordUsecase,
    required this.loginWithAppleUsecase,
    required this.empLoginUsingCachedUsecase,
  }) : super(EmpAuthInitial()) {
    on<EmpLoginEvent>(_onLoginEvent);
    on<EmpSignupEvent>(_onSignupEvent);
    on<EmpCheckEmailEvent>(_onCheckEmail);

    on<EmpVerifyOtpEvent>(_onVerifyOtpEvent);
    on<EmpResendOtpEvent>(_onResendOtpEvent);
    on<EmpForgotPasswordEvent>(_onForgotPasswordEvent);
    on<EmpLoginWithGoogleEvent>(_onLoginWithGoogle);
    on<EmpUpdatePasswordEvent>(_onUpdatePassword);
    on<EmpLoginWithAppleEvent>(_onLoginWithApple);
    on<EmpLoginWithCachedEvent>(_loginWithCached);
  }

  Future<void> _onLoginEvent(
    EmpLoginEvent event,
    Emitter<EmpAuthState> emit,
  ) async {
    emit(EmpAuthLoading());
    final result = await loginUsecase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(EmpAuthFailure(failure.message)),
      (user) => emit(EmpAuthSuccess(user)),
    );
  }

  Future<void> _onSignupEvent(
    EmpSignupEvent event,
    Emitter<EmpAuthState> emit,
  ) async {
    emit(EmpAuthLoading());
    final result = await signupUsecase(
      SignupParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold((failure) => emit(EmpAuthFailure(failure.message)), (user) {
      debugPrint("user data ${user.userId}");
      emit(EmpAuthSuccess(user));
    });
  }

  Future<void> _onCheckEmail(
    EmpCheckEmailEvent event,
    Emitter<EmpAuthState> emit,
  ) async {
    emit(EmpAuthLoading());
    final result = await checkEmailUsecase(
      CheckEmailParams(email: event.email),
    );

    result.fold(
      (failure) => emit(EmpAuthFailure(failure.message)),
      (success) => emit(EmpAuthCheckEmailVerified()),
    );
  }

  Future<void> _onVerifyOtpEvent(
    EmpVerifyOtpEvent event,
    Emitter<EmpAuthState> emit,
  ) async {
    emit(EmpAuthLoading());
    final result = await verifyOtpUsecase(
      VerifyOtpParams(email: event.email, otp: event.otp),
    );

    result.fold(
      (failure) => emit(EmpAuthFailure(failure.message)),
      (success) => emit(EmpAuthOtpVerified()),
    );
  }

  Future<void> _onResendOtpEvent(
    EmpResendOtpEvent event,
    Emitter<EmpAuthState> emit,
  ) async {
    emit(EmpAuthLoading());
    final result = await resendOtpUsecase(ResendOtpParams(email: event.email));

    result.fold(
      (failure) => emit(EmpAuthFailure(failure.message)),
      (success) => emit(EmpAuthOtpResent()),
    );
  }

  Future<void> _onForgotPasswordEvent(
    EmpForgotPasswordEvent event,
    Emitter<EmpAuthState> emit,
  ) async {
    emit(EmpAuthLoading());
    final result = await forgotPasswordUsecase(
      ForgotPasswordParams(email: event.email),
    );

    result.fold(
      (failure) => emit(EmpAuthFailure(failure.message)),
      (success) => emit(EmpAuthPasswordReset()),
    );
  }

  Future<void> _onLoginWithGoogle(
    EmpLoginWithGoogleEvent event,
    Emitter<EmpAuthState> emit,
  ) async {
    emit(EmpAuthLoading());
    final result = await loginWithGoogleUsecase(
      EmpLoginWithGoogleParams(idToken: event.idToken),
    );

    result.fold(
      (failure) => emit(EmpAuthFailure(failure.message)),
      (success) {
        debugPrint("Logged in successfully");
      },

      //  emit(AuthPasswordReset()),
    );
  }

  Future<void> _onUpdatePassword(
    EmpUpdatePasswordEvent event,
    Emitter<EmpAuthState> emit,
  ) async {
    emit(EmpAuthLoading());
    final result = await updatePasswordUsecase(
      EmpUpdatePasswordParams(newPassword: event.newPassword),
    );

    result.fold(
      (failure) => emit(EmpAuthFailure(failure.message)),
      (success) => emit(EmpAuthPasswordUpdated()),
    );
  }

  Future<void> _onLoginWithApple(
    EmpLoginWithAppleEvent event,
    Emitter<EmpAuthState> emit,
  ) async {
    emit(EmpAuthLoading());
    final result = await loginWithAppleUsecase(
      EmpLoginWithAppleParams(
        identityToken: event.identityToken,
        userData: event.userData,
      ),
    );

    result.fold(
      (failure) => emit(EmpAuthFailure(failure.message)),
      (user) => emit(EmpAuthSuccess(user)),
    );
  }

  Future<void> _loginWithCached(
    EmpLoginWithCachedEvent event,
    Emitter<EmpAuthState> emit,
  ) async {
    emit(EmpAuthLoading());
    final result = await empLoginUsingCachedUsecase();

    result.fold(
      (failure) => emit(EmpAuthFailure(failure.message)),
      (user) => emit(EmpAuthSuccess(user)),
    );
  }
}
