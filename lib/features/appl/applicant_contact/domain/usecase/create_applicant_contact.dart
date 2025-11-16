import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/entity/applicant_contact.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/repository/applicant_contact_repository.dart';

/// Use case for creating a new applicant contact.
class CreateApplicantContactUseCase extends UsecaseWithParams<ApplicantContact, ApplicantContact> {
  final ApplicantContactRepository _repository;

  CreateApplicantContactUseCase(this._repository);

  @override
  ResultFuture<ApplicantContact> call(ApplicantContact params) async {
    return await _repository.createContact(params);
  }
}