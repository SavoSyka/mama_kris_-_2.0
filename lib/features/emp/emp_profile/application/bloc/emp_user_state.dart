part of 'emp_user_bloc.dart';

abstract class EmpUserState {
  const EmpUserState();
}

class EmpUserInitial extends EmpUserState {
  const EmpUserInitial();
}

class EmpUserLoading extends EmpUserState {
  const EmpUserLoading();
}

class EmpUserLoaded extends EmpUserState {
  final EmpUserProfileEntity user;

  const EmpUserLoaded(this.user);
}

class EmpUserError extends EmpUserState {
  final String message;

  const EmpUserError(this.message);
}
