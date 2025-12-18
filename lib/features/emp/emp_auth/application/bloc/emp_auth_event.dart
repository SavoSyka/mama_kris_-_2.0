// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class EmpAuthEvent extends Equatable {
  const EmpAuthEvent();

  @override
  List<Object?> get props => [];
}

class EmpLoginEvent extends EmpAuthEvent {
  final String email;
  final String password;

  const EmpLoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class EmpSignupEvent extends EmpAuthEvent {
  final String name;
  final String email;
  final String password;

  const EmpSignupEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

class EmpCheckEmailEvent extends EmpAuthEvent {
  final String email;
  final bool isSubscribe;

  const EmpCheckEmailEvent({required this.email, required this.isSubscribe});

  @override
  List<Object?> get props => [email, isSubscribe];
}

class EmpVerifyOtpEvent extends EmpAuthEvent {
  final String email;
  final String otp;

  const EmpVerifyOtpEvent({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class EmpResendOtpEvent extends EmpAuthEvent {
  final String email;

  const EmpResendOtpEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class EmpForgotPasswordEvent extends EmpAuthEvent {
  final String email;

  const EmpForgotPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class EmpLoginWithGoogleEvent extends EmpAuthEvent {
  final String idToken;

  const EmpLoginWithGoogleEvent({required this.idToken});

  @override
  List<Object?> get props => [idToken];
}

class EmpUpdatePasswordEvent extends EmpAuthEvent {
  final String newPassword;

  const EmpUpdatePasswordEvent({required this.newPassword});

  @override
  List<Object?> get props => [newPassword];
}

class EmpLoginWithAppleEvent extends EmpAuthEvent {
  final String identityToken;
  final Map<String, dynamic> userData;

  const EmpLoginWithAppleEvent({
    required this.identityToken,
    required this.userData,
  });

  @override
  List<Object?> get props => [identityToken, userData];
}

class EmpLoginWithCachedEvent extends EmpAuthEvent {}
