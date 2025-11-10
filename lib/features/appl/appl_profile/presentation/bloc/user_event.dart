part of 'user_bloc.dart';

abstract class UserEvent {
  const UserEvent();
}

class GetUserProfileEvent extends UserEvent {
  final UserProfileEntity user;
  const GetUserProfileEvent({required this.user});
}
