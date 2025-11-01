import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserEntity user;

  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthOtpVerified extends AuthState {}
class AuthCheckEmailVerified extends AuthState {}


class AuthOtpResent extends AuthState {}

class AuthPasswordReset extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}