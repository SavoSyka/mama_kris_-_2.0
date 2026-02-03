import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/emp/employe_contact/domain/repository/employee_contact_repository.dart';

/// Use case for deleting an applicant contact by ID.
class DeleteEmployeeAccountUsecase extends UsecaseWithoutParams<bool> {
  final EmployeeContactRepository _repository;

  DeleteEmployeeAccountUsecase(this._repository);

  @override
  ResultFuture<bool> call() async {
    return await _repository.deleteUserAccount();
  }
}
