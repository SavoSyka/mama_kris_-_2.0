import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/employe_profile/domain/entity/email_verification_entity.dart';
import 'package:mama_kris/features/employe_profile/domain/repository/profile_repository.dart';

class VerifyEmailUsecase extends UsecaseWithParams<void, EmailVerificationEntity> {
  final ProfileRepository repository;

  VerifyEmailUsecase(this.repository);

  @override
  ResultFuture<void> call(EmailVerificationEntity params) async {
    return await repository.verifyEmail(params);
  }
}