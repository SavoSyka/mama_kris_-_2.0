part of 'user_bloc.dart';

abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final UserProfileEntity user;

  const UserLoaded(this.user);
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);
}

class UserUpdating extends UserState {
  const UserUpdating();
}

class UserUpdated extends UserState {
  final UserProfileEntity user;

  const UserUpdated(this.user);
}
