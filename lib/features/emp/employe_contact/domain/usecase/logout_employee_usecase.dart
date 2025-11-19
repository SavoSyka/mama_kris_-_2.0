import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/entity/applicant_contact.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/repository/applicant_contact_repository.dart';
import 'package:mama_kris/features/emp/employe_contact/domain/repository/employee_contact_repository.dart';

/// Use case for creating a new applicant contact.
class LogoutEmployeeUsecase extends UsecaseWithoutParams<bool> {
  final EmployeeContactRepository _repository;

  LogoutEmployeeUsecase(this._repository);

  @override
  ResultFuture<bool> call() async {
    return await _repository.logout();
  }
}
