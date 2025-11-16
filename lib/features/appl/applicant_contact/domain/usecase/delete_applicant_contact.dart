import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/repository/applicant_contact_repository.dart';

/// Use case for deleting an applicant contact by ID.
class DeleteApplicantContactUseCase extends UsecaseWithParams<bool, String> {
  final ApplicantContactRepository _repository;

  DeleteApplicantContactUseCase(this._repository);

  @override
  ResultFuture<bool> call(String params) async {
    return await _repository.deleteContact(params);
  }
}