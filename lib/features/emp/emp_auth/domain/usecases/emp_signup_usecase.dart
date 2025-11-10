import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_entity.dart';
import 'package:mama_kris/features/appl/app_auth/domain/repositories/auth_repository.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_entity.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/repositories/emp_auth_repository.dart';

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

class EmpSignupUsecase extends UseCase<EmpUserEntity, SignupParams> {
  final EmpAuthRepository repository;

  EmpSignupUsecase(this.repository);

  @override
  ResultFuture<EmpUserEntity> call(SignupParams params) async {
    return await repository.signup(params.name, params.email, params.password);
  }
}