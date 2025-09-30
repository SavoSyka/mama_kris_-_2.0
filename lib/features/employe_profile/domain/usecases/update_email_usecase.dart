import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/employe_profile/domain/entity/email_update_entity.dart';
import 'package:mama_kris/features/employe_profile/domain/repository/profile_repository.dart';

class UpdateEmailUsecase extends UsecaseWithParams<void, EmailUpdateEntity> {
  final ProfileRepository repository;

  UpdateEmailUsecase(this.repository);

  @override
  ResultFuture<void> call(EmailUpdateEntity params) async {
    return await repository.updateEmail(params);
  }
}