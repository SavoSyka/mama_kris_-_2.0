part of 'applicant_contact_bloc.dart';

/// Base class for all applicant contact states.
abstract class ApplicantContactState {
  const ApplicantContactState();
}

/// Initial state when the BLoC is first created.
class ApplicantContactInitial extends ApplicantContactState {
  const ApplicantContactInitial();
}

/// State indicating that an operation is in progress.
class ApplicantContactLoading extends ApplicantContactState {
  const ApplicantContactLoading();
}

/// State when contacts are successfully loaded.
class ApplicantContactLoaded extends ApplicantContactState {
  final List<ApplicantContact> contacts;

  const ApplicantContactLoaded(this.contacts);
}

/// State when a contact is successfully created.
class ApplicantContactCreated extends ApplicantContactState {
  final ApplicantContact contact;

  const ApplicantContactCreated(this.contact);
}

/// State when a contact is successfully updated.
class ApplicantContactUpdated extends ApplicantContactState {
  final ApplicantContact contact;

  const ApplicantContactUpdated(this.contact);
}

/// State when a contact is successfully deleted.
class ApplicantContactDeleted extends ApplicantContactState {
  const ApplicantContactDeleted();
}

/// State when an operation fails.
class ApplicantContactError extends ApplicantContactState {
  final String message;

  const ApplicantContactError(this.message);
}

class ApplicantWorkExpereinceUpdated extends ApplicantContactState {
  const ApplicantWorkExpereinceUpdated();
}

class UserAccountDeleted extends ApplicantContactState {
  const UserAccountDeleted();
}
