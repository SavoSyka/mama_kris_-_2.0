import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/applicant_welcome/domain/entities/user.dart';


abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthLoading extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthEmailChecked extends AuthState {
  final bool exists;
  AuthEmailChecked(this.exists);
  
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthOtpValidated extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Authenticated extends AuthState {
  final User user;
  Authenticated(this.user);
  
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
  
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class CheckEmailErroState extends AuthState {
  final String message;
  CheckEmailErroState(this.message);
  
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}