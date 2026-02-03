import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/emp/employe_contact/domain/repository/employee_contact_repository.dart';

/// Use case for deleting an applicant contact by ID.
class DeleteEmployeeContact extends UsecaseWithParams<bool, String> {
  final EmployeeContactRepository _repository;

  DeleteEmployeeContact(this._repository);

  @override
  ResultFuture<bool> call(String params) async {
    return await _repository.deleteContact(params);
  }
}