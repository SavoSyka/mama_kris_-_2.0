part of 'applicant_contact_bloc.dart';

/// Base class for all applicant contact events.
abstract class ApplicantContactEvent {
  const ApplicantContactEvent();
}

/// Event to load all applicant contacts.
class LoadApplicantContactsEvent extends ApplicantContactEvent {
  const LoadApplicantContactsEvent();
}

/// Event to create a new applicant contact.
class CreateApplicantContactEvent extends ApplicantContactEvent {
  final ApplicantContact contact;

  const CreateApplicantContactEvent({required this.contact});
}

/// Event to update an existing applicant contact.
class UpdateApplicantContactEvent extends ApplicantContactEvent {
  final String id;
  final ApplicantContact contact;

  const UpdateApplicantContactEvent({
    required this.id,
    required this.contact,
  });
}

/// Event to delete an applicant contact by ID.
class DeleteApplicantContactEvent extends ApplicantContactEvent {
  final String id;

  const DeleteApplicantContactEvent({required this.id});
}