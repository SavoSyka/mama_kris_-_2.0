part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  const UserInitial();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserLoading extends UserState {
  const UserLoading();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserLoaded extends UserState {
  final UserProfileEntity user;

  const UserLoaded(this.user);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserUpdating extends UserState {
  const UserUpdating();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserUpdated extends UserState {
  final UserProfileEntity user;

  const UserUpdated(this.user);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
