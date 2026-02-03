import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_entity.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/repositories/emp_auth_repository.dart';

class EmpLoginWithAppleParams {
  final String identityToken;
  final Map<String, dynamic> userData;

  const EmpLoginWithAppleParams({
    required this.identityToken,
    required this.userData,
  });
}

class EmpLoginWithAppleUsecase
    extends UseCase<EmpUserEntity, EmpLoginWithAppleParams> {
  final EmpAuthRepository repository;

  EmpLoginWithAppleUsecase(this.repository);

  @override
  ResultFuture<EmpUserEntity> call(EmpLoginWithAppleParams params) async {
    return await repository.loginWithApple(
      identityToken: params.identityToken,
      userData: params.userData,
    );
  }
}
