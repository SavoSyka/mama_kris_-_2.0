
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/auth/domain/repository/auth_repository.dart';

class ValidateOtp {
  final AuthRepository repository;
  ValidateOtp(this.repository);

  ResultFuture<bool> call(String email, String otp) async {
    return await repository.validateOtp(email, otp);
  }
}
