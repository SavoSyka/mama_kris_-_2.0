part of 'profile_update_bloc.dart';

abstract class ProfileUpdateEvent {
  const ProfileUpdateEvent();
}

class UpdateEmailEvent extends ProfileUpdateEvent {
  final String email;

  const UpdateEmailEvent({required this.email});
}

class VerifyEmailEvent extends ProfileUpdateEvent {
  final String otp;

  const VerifyEmailEvent({required this.otp});
}

class UpdateContactsEvent extends ProfileUpdateEvent {
  final ContactEntity contacts;

  const UpdateContactsEvent({required this.contacts});
}

class UpdatePasswordEvent extends ProfileUpdateEvent {
  final String oldPassword;
  final String newPassword;

  const UpdatePasswordEvent({
    required this.oldPassword,
    required this.newPassword,
  });
}

class UpdateAboutEvent extends ProfileUpdateEvent {
  final String description;

  const UpdateAboutEvent({required this.description});
}