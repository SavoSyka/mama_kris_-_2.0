import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/repositories/emp_auth_repository.dart';

class VerifyOtpParams {
  final String email;
  final String otp;

  const VerifyOtpParams({required this.email, required this.otp});
}

class EmpVerifyOtpUsecase extends UseCase<bool, VerifyOtpParams> {
  final EmpAuthRepository repository;

  EmpVerifyOtpUsecase(this.repository);

  @override
  ResultFuture<bool> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(params.email, params.otp);
  }
}