import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/entity/applicant_contact.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/repository/applicant_contact_repository.dart';

/// Parameters for updating an applicant contact.
class UpdateApplicantContactParams {
  final String id;
  final ApplicantContact contact;

  const UpdateApplicantContactParams({
    required this.id,
    required this.contact,
  });
}

/// Use case for updating an existing applicant contact.
class UpdateApplicantContactUseCase extends UsecaseWithParams<ApplicantContact, UpdateApplicantContactParams> {
  final ApplicantContactRepository _repository;

  UpdateApplicantContactUseCase(this._repository);

  @override
  ResultFuture<ApplicantContact> call(UpdateApplicantContactParams params) async {
    return await _repository.updateContact(params.id, params.contact);
  }
}


