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

  const EmpCheckEmailEvent({required this.email,});

  @override
  List<Object?> get props => [email, ];
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