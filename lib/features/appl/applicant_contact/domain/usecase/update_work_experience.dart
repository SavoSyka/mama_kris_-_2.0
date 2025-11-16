import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/entity/applicant_contact.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/repository/applicant_contact_repository.dart';

/// Use case for updating an existing applicant contact.
class UpdateApplicantContactUseCase
    extends UsecaseWithParams<bool, List<ApplWorkExperienceEntity>> {
  final ApplicantContactRepository _repository;

  UpdateApplicantContactUseCase(this._repository);

  @override
  ResultFuture<bool> call(List<ApplWorkExperienceEntity> data) async {
    return await _repository.updateExperience(data);
  }
}
