import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_entity.dart';
import 'package:mama_kris/features/appl/app_auth/domain/repositories/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}

class LoginUsecase extends UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  @override
  ResultFuture<UserEntity> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}