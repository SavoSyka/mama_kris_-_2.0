part of 'user_bloc.dart';

abstract class UserEvent {
  const UserEvent();
}

class GetUserProfileEvent extends UserEvent {
  final UserProfileEntity user;
  const GetUserProfileEvent({required this.user});
}

class UpdateUserProfileEvent extends UserEvent {
  final UserProfileEntity updatedUser;
  const UpdateUserProfileEvent({required this.updatedUser});
}

class AddContactEvent extends UserEvent {
  final ApplContactEntity newContact;
  AddContactEvent(this.newContact);
}

class EditContactEvent extends UserEvent {
  final ApplContactEntity updatedContact;
  EditContactEvent(this.updatedContact);
}

class DeleteContactEvent extends UserEvent {
  final int contactId;
  DeleteContactEvent(this.contactId);
}

class UpdateWorkExperienceEvent extends UserEvent {
  final List<ApplWorkExperienceEntity> updated;
  UpdateWorkExperienceEvent(this.updated);
}
