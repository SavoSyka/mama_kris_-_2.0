part of 'employee_contact_bloc.dart';

/// Base class for all applicant contact states.
abstract class EmployeeContactState {
  const EmployeeContactState();
}

/// Initial state when the BLoC is first created.
class EmployeeContactInitial extends EmployeeContactState {
  const EmployeeContactInitial();
}

/// State indicating that an operation is in progress.
class EmployeeContactLoading extends EmployeeContactState {
  const EmployeeContactLoading();
}

/// State when contacts are successfully loaded.
class EmployeeContactLoaded extends EmployeeContactState {
  final List<EmployeeContact> contacts;

  const EmployeeContactLoaded(this.contacts);
}

/// State when a contact is successfully created.
class EmployeeContactCreated extends EmployeeContactState {
  final EmployeeContact contact;

  const EmployeeContactCreated(this.contact);
}

/// State when a contact is successfully updated.
class EmployeeContactUpdated extends EmployeeContactState {
  final EmployeeContact contact;

  const EmployeeContactUpdated(this.contact);
}

/// State when a contact is successfully deleted.
class EmployeeContactDeleted extends EmployeeContactState {
  const EmployeeContactDeleted();
}

/// State when an operation fails.
class EmployeeContactError extends EmployeeContactState {
  final String message;

  const EmployeeContactError(this.message);
}

class ApplicantWorkExpereinceUpdated extends EmployeeContactState {
  const ApplicantWorkExpereinceUpdated();
}

class UserAccountDeleted extends EmployeeContactState {
  const UserAccountDeleted();
}



class UserBasicInfoUpdated extends EmployeeContactState {
  const UserBasicInfoUpdated();
}

class AccountDeleteLoadingState extends EmployeeContactState {
  const AccountDeleteLoadingState();
}