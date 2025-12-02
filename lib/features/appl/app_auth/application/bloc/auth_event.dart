import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignupEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const SignupEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

class CheckEmailEvent extends AuthEvent {
  final String email;

  const CheckEmailEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class VerifyOtpEvent extends AuthEvent {
  final String email;
  final String otp;

  const VerifyOtpEvent({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class ResendOtpEvent extends AuthEvent {
  final String email;

  const ResendOtpEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  const ForgotPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class LoginWithGoogleEvent extends AuthEvent {
  final String idToken;

  const LoginWithGoogleEvent({required this.idToken});

  @override
  List<Object?> get props => [idToken];
}

class UpdatePasswordEvent extends AuthEvent {
  final String newPassword;

  const UpdatePasswordEvent({required this.newPassword});

  @override
  List<Object?> get props => [newPassword];
}

class LoginWithAppleEvent extends AuthEvent {
  final String identityToken;
  final Map<String, dynamic> userData;

  const LoginWithAppleEvent({
    required this.identityToken,
    required this.userData,
  });

  @override
  List<Object?> get props => [identityToken, userData];
}

class LoginWithCachedEvent extends AuthEvent {}
