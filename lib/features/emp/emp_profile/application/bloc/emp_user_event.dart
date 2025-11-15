part of 'emp_user_bloc.dart';

abstract class UserEvent {
  const UserEvent();
}

class EmpGetUserProfileEvent extends UserEvent {
  final EmpUserProfileEntity user;
  const EmpGetUserProfileEvent({required this.user});
}

class EmpUpdateUserProfileEvent extends UserEvent {
  final EmpUserProfileEntity updatedUser;
  const EmpUpdateUserProfileEvent({required this.updatedUser});
}
