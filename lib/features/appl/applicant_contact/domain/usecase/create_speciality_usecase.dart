import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/entity/applicant_contact.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/repository/applicant_contact_repository.dart';

/// Use case for creating a new applicant contact.
class CreateSpecialityUsecase extends UsecaseWithParams<bool, String> {
  final ApplicantContactRepository _repository;

  CreateSpecialityUsecase(this._repository);

  @override
  ResultFuture<bool> call(String params) async {
    return await _repository.addSpeciality(params);
  }
}
