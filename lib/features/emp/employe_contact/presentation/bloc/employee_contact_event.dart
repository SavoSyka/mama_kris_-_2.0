part of 'employee_contact_bloc.dart';

/// Base class for all applicant contact events.
abstract class EmployeeContactEvent {
  const EmployeeContactEvent();
}

/// Event to load all applicant contacts.
class LoadApplicantContactsEvent extends EmployeeContactEvent {
  const LoadApplicantContactsEvent();
}

/// Event to create a new applicant contact.
class CreateEmployeeContactEvent extends EmployeeContactEvent {
  final EmployeeContact contact;

  const CreateEmployeeContactEvent({required this.contact});
}

/// Event to update an existing applicant contact.
class UpdateEmployeeContactEvent extends EmployeeContactEvent {
  final String id;
  final EmployeeContact contact;

  const UpdateEmployeeContactEvent({required this.id, required this.contact});
}

/// Event to delete an applicant contact by ID.
class DeleteEmployeeContactEvent extends EmployeeContactEvent {
  final String id;

  const DeleteEmployeeContactEvent({required this.id});
}

class DeleteUserAccountEvent extends EmployeeContactEvent {
  const DeleteUserAccountEvent();
}

class UpdatingBasicInfoEvent extends EmployeeContactEvent {
  final String name;
  final String dob;

  const UpdatingBasicInfoEvent({required this.name, required this.dob});
}

class EmpLogoutAccountEvent extends EmployeeContactEvent {
  const EmpLogoutAccountEvent();
}