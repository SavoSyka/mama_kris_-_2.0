import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/entity/applicant_contact.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/repository/applicant_contact_repository.dart';
import 'package:mama_kris/features/emp/employe_contact/domain/entity/employee_contact.dart';
import 'package:mama_kris/features/emp/employe_contact/domain/repository/employee_contact_repository.dart';

/// Parameters for updating an applicant contact.
class UpdateEmployeeContactParams {
  final String id;
  final EmployeeContact contact;

  const UpdateEmployeeContactParams({required this.id, required this.contact});
}

/// Use case for updating an existing applicant contact.
class UpdateEmployeeContact
    extends UsecaseWithParams<EmployeeContact, UpdateEmployeeContactParams> {
  final EmployeeContactRepository _repository;

  UpdateEmployeeContact(this._repository);

  @override
  ResultFuture<EmployeeContact> call(UpdateEmployeeContactParams params) async {
    return await _repository.updateContact(params.id, params.contact);
  }
}
