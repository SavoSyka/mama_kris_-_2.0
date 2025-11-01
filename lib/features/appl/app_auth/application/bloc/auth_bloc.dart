import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_event.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_state.dart';
import 'package:mama_kris/features/appl/app_auth/domain/usecases/check_email_usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/usecases/forgot_password_usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/usecases/login_usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/usecases/resend_otp_usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/usecases/signup_usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/usecases/verify_otp_usecase.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final SignupUsecase signupUsecase;
  final CheckEmailUsecase checkEmailUsecase;

  final VerifyOtpUsecase verifyOtpUsecase;
  final ResendOtpUsecase resendOtpUsecase;
  final ForgotPasswordUsecase forgotPasswordUsecase;


  AuthBloc({
    required this.loginUsecase,
    required this.signupUsecase,
    required this.checkEmailUsecase,

    required this.verifyOtpUsecase,
    required this.resendOtpUsecase,
    required this.forgotPasswordUsecase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<SignupEvent>(_onSignupEvent);
    on<CheckEmailEvent>(_onCheckEmail);

    on<VerifyOtpEvent>(_onVerifyOtpEvent);
    on<ResendOtpEvent>(_onResendOtpEvent);
    on<ForgotPasswordEvent>(_onForgotPasswordEvent);
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUsecase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> _onSignupEvent(
    SignupEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signupUsecase(
      SignupParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold((failure) => emit(AuthFailure(failure.message)), (user) {
      debugPrint("user data ${user.userId}");
      emit(AuthSuccess(user));
    });
  }



    Future<void> _onCheckEmail(
    CheckEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await checkEmailUsecase(
      CheckEmailParams(email: event.email,),
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (success) => emit(AuthCheckEmailVerified()),
    );
  }

  Future<void> _onVerifyOtpEvent(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await verifyOtpUsecase(
      VerifyOtpParams(email: event.email, otp: event.otp),
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (success) => emit(AuthOtpVerified()),
    );
  }

  Future<void> _onResendOtpEvent(
    ResendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await resendOtpUsecase(ResendOtpParams(email: event.email));

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (success) => emit(AuthOtpResent()),
    );
  }

  Future<void> _onForgotPasswordEvent(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await forgotPasswordUsecase(
      ForgotPasswordParams(email: event.email),
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (success) => emit(AuthPasswordReset()),
    );
  }
}
