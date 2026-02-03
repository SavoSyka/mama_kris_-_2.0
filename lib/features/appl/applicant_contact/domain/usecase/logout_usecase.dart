import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/repository/applicant_contact_repository.dart';

/// Use case for creating a new applicant contact.
class LogoutUsecase extends UsecaseWithoutParams<bool> {
  final ApplicantContactRepository _repository;

  LogoutUsecase(this._repository);

  @override
  ResultFuture<bool> call() async {
    return await _repository.logout();
  }
}
