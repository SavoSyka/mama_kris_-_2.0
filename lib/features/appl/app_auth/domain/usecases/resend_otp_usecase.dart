import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/repositories/auth_repository.dart';

class ResendOtpParams {
  final String email;

  const ResendOtpParams({required this.email});
}

class ResendOtpUsecase extends UseCase<bool, ResendOtpParams> {
  final AuthRepository repository;

  ResendOtpUsecase(this.repository);

  @override
  ResultFuture<bool> call(ResendOtpParams params) async {
    return await repository.resendOtp(params.email);
  }
}