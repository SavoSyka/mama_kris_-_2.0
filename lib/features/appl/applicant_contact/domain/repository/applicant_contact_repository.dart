import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/entity/applicant_contact.dart';

/// Abstract repository interface for applicant contact operations.
/// This defines the contract for data access in the domain layer.
abstract class ApplicantContactRepository {
  /// Creates a new applicant contact.
  /// Returns the created contact with generated ID.
  ResultFuture<ApplicantContact> createContact(ApplicantContact contact);

  /// Updates an existing applicant contact by ID.
  /// Returns the updated contact.
  ResultFuture<ApplicantContact> updateContact(
    String id,
    ApplicantContact contact,
  );

  /// Deletes an applicant contact by ID.
  /// Returns true if deletion was successful.
  ResultFuture<bool> deleteContact(String id);

  /// Retrieves an applicant contact by ID.
  /// Returns null if not found.
  ResultFuture<ApplicantContact?> getContact(String id);

  /// Retrieves all applicant contacts.
  /// Returns an empty list if none found.
  ResultFuture<List<ApplicantContact>> getAllContacts();

  ResultFuture<bool> updateExperience(
    List<ApplWorkExperienceEntity> experience,
  );

  ResultFuture<bool> deleteUserAccount();

  ResultFuture<bool> updateBasicInfo({required String name, required String dob});

  ResultFuture<bool> addSpeciality(String speciality);

  ResultFuture<bool> logout();

}
