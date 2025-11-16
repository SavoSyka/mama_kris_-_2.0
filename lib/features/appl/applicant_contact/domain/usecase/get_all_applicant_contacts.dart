import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/entity/applicant_contact.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/repository/applicant_contact_repository.dart';

/// Use case for retrieving all applicant contacts.
class GetAllApplicantContactsUseCase extends UsecaseWithoutParams<List<ApplicantContact>> {
  final ApplicantContactRepository _repository;

  GetAllApplicantContactsUseCase(this._repository);

  @override
  ResultFuture<List<ApplicantContact>> call() async {
    return await _repository.getAllContacts();
  }
}