import 'package:mama_kris/features/appl/app_auth/data/models/user_profile_model.dart';
import 'package:mama_kris/features/appl/applicant_contact/data/model/applicant_contact_model.dart';
import 'package:mama_kris/features/emp/employe_contact/data/model/employee_contact_model.dart';

/// Abstract data source interface for applicant contact operations.
/// Defines the contract for external data access (API, local storage, etc.).
abstract class EmployeeContactDataSource {
  /// Creates a new applicant contact.
  Future<EmployeeContactModel> createContact(EmployeeContactModel contact);

  /// Updates an existing applicant contact by ID.
  Future<EmployeeContactModel> updateContact(
    String id,
    EmployeeContactModel contact,
  );

  /// Deletes an applicant contact by ID.
  Future<bool> deleteContact(String id);

  /// Retrieves an applicant contact by ID.
  Future<EmployeeContactModel?> getContact(String id);

  /// Retrieves all applicant contacts.
  Future<List<EmployeeContactModel>> getAllContacts();

  Future<bool> updateExperience(List<WorkExperienceModel> experience);

  Future<bool> deleteUserAccount();

  Future<bool> updateBasicInfo({required String name, required String dob});
}
