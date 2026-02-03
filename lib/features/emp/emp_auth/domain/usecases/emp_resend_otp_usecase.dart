import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/repositories/emp_auth_repository.dart';

class ResendOtpParams {
  final String email;

  const ResendOtpParams({required this.email});
}

class EmpResendOtpUsecase extends UseCase<bool, ResendOtpParams> {
  final EmpAuthRepository repository;

  EmpResendOtpUsecase(this.repository);

  @override
  ResultFuture<bool> call(ResendOtpParams params) async {
    return await repository.resendOtp(params.email);
  }
}