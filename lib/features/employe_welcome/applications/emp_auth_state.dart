import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/applicant_welcome/domain/entities/user.dart';
import 'package:mama_kris/features/employe_welcome/domain/entities/employe_user.dart';

abstract class EmpAuthState extends Equatable {}

class AuthInitial extends EmpAuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthLoading extends EmpAuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthEmailChecked extends EmpAuthState {
  final bool exists;
  AuthEmailChecked(this.exists);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthOtpValidated extends EmpAuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Authenticated extends EmpAuthState {
  final EmployeUser user;
  Authenticated(this.user);

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class AuthError extends EmpAuthState {
  final String message;
  AuthError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class CheckEmailErroState extends EmpAuthState {
  final String message;
  CheckEmailErroState(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
