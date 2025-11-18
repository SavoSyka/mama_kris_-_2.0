part of 'emp_user_bloc.dart';

abstract class EmpUserEvent {
  const EmpUserEvent();
}

class EmpGetUserProfileEvent extends EmpUserEvent {
  final EmpUserProfileEntity user;
  const EmpGetUserProfileEvent({required this.user});
}

class EmpUpdateUserProfileEvent extends EmpUserEvent {
  final EmpUserProfileEntity updatedUser;
  const EmpUpdateUserProfileEvent({required this.updatedUser});
}

class EmpAddContactEvent extends EmpUserEvent {
  final ContactEntity newContact;
  EmpAddContactEvent(this.newContact);
}

class EmpEditContactEvent extends EmpUserEvent {
  final ContactEntity updatedContact;
  EmpEditContactEvent(this.updatedContact);
}

class EmpDeleteContactEvent extends EmpUserEvent {
  final int contactId;
  EmpDeleteContactEvent(this.contactId);
}

class EmpUpdateBasicInfoEvent extends EmpUserEvent {
  final String name;
  final String dob;

  EmpUpdateBasicInfoEvent({required this.name, required this.dob});
}
