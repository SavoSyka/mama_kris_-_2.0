import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/employe_profile/domain/entity/password_update_entity.dart';
import 'package:mama_kris/features/employe_profile/domain/repository/profile_repository.dart';

class UpdatePasswordUsecase extends UsecaseWithParams<void, PasswordUpdateEntity> {
  final ProfileRepository repository;

  UpdatePasswordUsecase(this.repository);

  @override
  ResultFuture<void> call(PasswordUpdateEntity params) async {
    return await repository.updatePassword(params);
  }
}