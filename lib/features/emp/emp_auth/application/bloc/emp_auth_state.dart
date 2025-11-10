import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_entity.dart';

abstract class EmpAuthState extends Equatable {
  const EmpAuthState();

  @override
  List<Object?> get props => [];
}

class  EmpAuthInitial extends EmpAuthState {}

class  EmpAuthLoading extends EmpAuthState {}

class  EmpAuthSuccess extends EmpAuthState {
  final EmpUserEntity user;

  const  EmpAuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class  EmpAuthOtpVerified extends EmpAuthState {}
class  EmpAuthCheckEmailVerified extends EmpAuthState {}


class  EmpAuthOtpResent extends EmpAuthState {}

class  EmpAuthPasswordReset extends EmpAuthState {}

class  EmpAuthFailure extends EmpAuthState {
  final String message;

  const  EmpAuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}