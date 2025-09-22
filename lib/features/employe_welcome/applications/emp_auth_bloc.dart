import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/features/applicant_welcome/domain/usecases/change_password.dart';
import 'package:mama_kris/features/applicant_welcome/domain/usecases/check_email.dart';
import 'package:mama_kris/features/applicant_welcome/domain/usecases/forgot_password_usecase.dart';
import 'package:mama_kris/features/applicant_welcome/domain/usecases/login_applicant.dart';
import 'package:mama_kris/features/applicant_welcome/domain/usecases/register_applicant.dart';
import 'package:mama_kris/features/applicant_welcome/domain/usecases/validate_otp.dart';
import 'package:mama_kris/features/employe_welcome/domain/usecases/emp_change_pass_usecase.dart';
import 'package:mama_kris/features/employe_welcome/domain/usecases/emp_check_email_usecase.dart';
import 'package:mama_kris/features/employe_welcome/domain/usecases/emp_forgot_pass_usecase.dart';
import 'package:mama_kris/features/employe_welcome/domain/usecases/emp_login_usecase.dart';
import 'package:mama_kris/features/employe_welcome/domain/usecases/emp_register_usecase.dart';
import 'package:mama_kris/features/employe_welcome/domain/usecases/emp_validat_otp_usecase.dart';

import 'emp_auth_event.dart';
import 'emp_auth_state.dart';

class EmpAuthBloc extends Bloc<EmpAuthEvent, EmpAuthState> {
  final EmpCheckEmailUsecase checkEmail;
  final EmpForgotPassUsecase forgotPassword;
  final EmpValidatOtpUsecase validateOtp;
  final EmpRegisterUsecase register;
  final EmpLoginUsecase login;
  final EmpChangePassUsecase changePassword;

  EmpAuthBloc({
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
        final exists = await checkEmail(CheckEmailParams(email: event.email));
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
             final exists = await forgotPassword(ForgotParams(email: event.email));

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
             final valid = await validateOtp(ValidateOtpParams(email: event.email, otp: event.otp));


        valid.fold(
          (failure) {
            emit(AuthError(failure.message));
          },
          (success) {
            emit(AuthEmailChecked(true));
          },
        );
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());
      try {
             final user = await register(RegisterParams(email: event.email, name: event.name, password: event.password));


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
             final user = await login(LoginParams(email: event.email, password: event.password));

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
             final user = await changePassword(ChangePassParams( password: event.password));

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
