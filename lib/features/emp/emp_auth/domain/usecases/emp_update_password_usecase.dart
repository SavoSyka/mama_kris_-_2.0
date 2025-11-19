import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/repositories/auth_repository.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/repositories/emp_auth_repository.dart';

class EmpUpdatePasswordParams {
  final String newPassword;

  const EmpUpdatePasswordParams({required this.newPassword});
}

class EmpUpdatePasswordUsecase extends UseCase<bool, EmpUpdatePasswordParams> {
  final EmpAuthRepository repository;

  EmpUpdatePasswordUsecase(this.repository);

  @override
  ResultFuture<bool> call(EmpUpdatePasswordParams params) async {
    return await repository.updatePassword(params.newPassword);
  }
}
