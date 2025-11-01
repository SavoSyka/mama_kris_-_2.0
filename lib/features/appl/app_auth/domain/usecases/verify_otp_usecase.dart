import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/repositories/auth_repository.dart';

class VerifyOtpParams {
  final String email;
  final String otp;

  const VerifyOtpParams({required this.email, required this.otp});
}

class VerifyOtpUsecase extends UseCase<bool, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtpUsecase(this.repository);

  @override
  ResultFuture<bool> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(params.email, params.otp);
  }
}