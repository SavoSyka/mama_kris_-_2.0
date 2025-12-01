import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/entity/applicant_contact.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/repository/applicant_contact_repository.dart';
import 'package:mama_kris/features/emp/employe_contact/domain/repository/employee_contact_repository.dart';

/// Parameters for updating an applicant contact.
class UpdateEmpBasicInfoParams {
  final String name;
  final String dob;
  final String about;


  const UpdateEmpBasicInfoParams({required this.name, required this.dob, required this.about});
}

/// Use case for updating an existing applicant contact.
class UpdateEmployeeBasicInfoUsecase
    extends UsecaseWithParams<bool, UpdateEmpBasicInfoParams> {
  final EmployeeContactRepository _repository;

  UpdateEmployeeBasicInfoUsecase(this._repository);

  @override
  ResultFuture<bool> call(UpdateEmpBasicInfoParams params) async {
    return await _repository.updateBasicInfo(
      name: params.name,
      dob: params.dob,
      about: params.about
    );
  }
}
