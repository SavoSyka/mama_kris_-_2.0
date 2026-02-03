import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_entity.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/repositories/emp_auth_repository.dart';

class EmpLoginUsingCachedUsecase extends UsecaseWithoutParams<EmpUserEntity> {
  final EmpAuthRepository repository;

  EmpLoginUsingCachedUsecase(this.repository);

  @override
  ResultFuture<EmpUserEntity> call() async {
    return await repository.loginUsingCached();
  }
}
