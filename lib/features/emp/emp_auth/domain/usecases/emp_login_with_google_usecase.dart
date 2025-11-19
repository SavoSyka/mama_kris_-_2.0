import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/repositories/auth_repository.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/repositories/emp_auth_repository.dart';

class EmpLoginWithGoogleParams {
  final String idToken;

  const EmpLoginWithGoogleParams({required this.idToken});
}

class EmpLoginWithGoogleUsecase
    extends UseCase<bool, EmpLoginWithGoogleParams> {
  final EmpAuthRepository repository;

  EmpLoginWithGoogleUsecase(this.repository);

  @override
  ResultFuture<bool> call(EmpLoginWithGoogleParams params) async {
    return await repository.loginWithGoogle(idToken: params.idToken);
  }
}
