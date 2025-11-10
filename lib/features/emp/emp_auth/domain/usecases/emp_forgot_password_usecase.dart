import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/repositories/auth_repository.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/repositories/emp_auth_repository.dart';

class ForgotPasswordParams {
  final String email;

  const ForgotPasswordParams({required this.email});
}

class EmpForgotPasswordUsecase extends UseCase<bool, ForgotPasswordParams> {
  final EmpAuthRepository repository;

  EmpForgotPasswordUsecase(this.repository);

  @override
  ResultFuture<bool> call(ForgotPasswordParams params) async {
    return await repository.forgotPassword(params.email);
  }
}