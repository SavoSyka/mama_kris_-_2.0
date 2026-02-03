import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_entity.dart';
import 'package:mama_kris/features/appl/app_auth/domain/repositories/auth_repository.dart';

class SignupParams {
  final String name;
  final String email;
  final String password;

  const SignupParams({
    required this.name,
    required this.email,
    required this.password,
  });
}

class SignupUsecase extends UseCase<UserEntity, SignupParams> {
  final AuthRepository repository;

  SignupUsecase(this.repository);

  @override
  ResultFuture<UserEntity> call(SignupParams params) async {
    return await repository.signup(params.name, params.email, params.password);
  }
}