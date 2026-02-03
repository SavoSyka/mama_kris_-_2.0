import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_entity.dart';
import 'package:mama_kris/features/appl/app_auth/domain/repositories/auth_repository.dart';

class LoginWithAppleParams {
  final String identityToken;
  final Map<String, dynamic> userData;

  const LoginWithAppleParams({
    required this.identityToken,
    required this.userData,
  });
}

class LoginWithAppleUsecase extends UseCase<UserEntity, LoginWithAppleParams> {
  final AuthRepository repository;

  LoginWithAppleUsecase(this.repository);

  @override
  ResultFuture<UserEntity> call(LoginWithAppleParams params) async {
    return await repository.loginWithApple(
      identityToken: params.identityToken,
      userData: params.userData,
    );
  }
}
