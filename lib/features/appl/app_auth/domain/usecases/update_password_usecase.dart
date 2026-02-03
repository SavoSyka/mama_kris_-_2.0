import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/repositories/auth_repository.dart';

class UpdatePasswordParams {
  final String newPassword;

  const UpdatePasswordParams({required this.newPassword});
}

class UpdatePasswordUsecase extends UseCase<bool, UpdatePasswordParams> {
  final AuthRepository repository;

  UpdatePasswordUsecase(this.repository);

  @override
  ResultFuture<bool> call(UpdatePasswordParams params) async {
    return await repository.updatePassword(params.newPassword);
  }
}
