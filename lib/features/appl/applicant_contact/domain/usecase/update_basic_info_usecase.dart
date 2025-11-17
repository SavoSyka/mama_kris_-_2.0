import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/entity/applicant_contact.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/repository/applicant_contact_repository.dart';

/// Parameters for updating an applicant contact.
class UpdateBasicInfoParams {
  final String name;
  final String dob;

  const UpdateBasicInfoParams({required this.name, required this.dob});
}

/// Use case for updating an existing applicant contact.
class UpdateBasicInfoUsecase
    extends UsecaseWithParams<bool, UpdateBasicInfoParams> {
  final ApplicantContactRepository _repository;

  UpdateBasicInfoUsecase(this._repository);

  @override
  ResultFuture<bool> call(UpdateBasicInfoParams params) async {
    return await _repository.updateBasicInfo(
      name: params.name,
      dob: params.dob,
    );
  }
}
