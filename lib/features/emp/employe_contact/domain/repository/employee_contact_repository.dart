import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/entity/applicant_contact.dart';
import 'package:mama_kris/features/emp/employe_contact/domain/entity/employee_contact.dart';

/// Abstract repository interface for applicant contact operations.
/// This defines the contract for data access in the domain layer.
abstract class EmployeeContactRepository {
  /// Creates a new applicant contact.
  /// Returns the created contact with generated ID.
  ResultFuture<EmployeeContact> createContact(EmployeeContact contact);

  /// Updates an existing applicant contact by ID.
  /// Returns the updated contact.
  ResultFuture<EmployeeContact> updateContact(
    String id,
    EmployeeContact contact,
  );

  /// Deletes an applicant contact by ID.
  /// Returns true if deletion was successful.
  ResultFuture<bool> deleteContact(String id);

  /// Retrieves an applicant contact by ID.
  /// Returns null if not found.

  ResultFuture<List<EmployeeContact>> getAllContacts();

  ResultFuture<bool> deleteUserAccount();

  ResultFuture<bool> updateBasicInfo({
    required String name,
    required String dob,
    required String about,

  });

  ResultFuture<bool> logout();
}
