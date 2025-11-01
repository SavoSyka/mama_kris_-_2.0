import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/repositories/auth_repository.dart';

class ForgotPasswordParams {
  final String email;

  const ForgotPasswordParams({required this.email});
}

class ForgotPasswordUsecase extends UseCase<bool, ForgotPasswordParams> {
  final AuthRepository repository;

  ForgotPasswordUsecase(this.repository);

  @override
  ResultFuture<bool> call(ForgotPasswordParams params) async {
    return await repository.forgotPassword(params.email);
  }
}