import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_entity.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/repositories/emp_auth_repository.dart';

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}

class EmpLoginUsecase extends UseCase<EmpUserEntity, LoginParams> {
  final EmpAuthRepository repository;

  EmpLoginUsecase(this.repository);

  @override
  ResultFuture<EmpUserEntity> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}