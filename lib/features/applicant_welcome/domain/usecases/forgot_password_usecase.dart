import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/applicant_welcome/domain/repository/auth_repository.dart';

class ForgotPasswordUsecase {
  final AuthRepository repository;
  ForgotPasswordUsecase(this.repository);

  ResultFuture<bool> call(String email) async {
    return await repository.forgotPassword(email);
  }
}
