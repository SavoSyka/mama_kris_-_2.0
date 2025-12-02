import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_entity.dart';
import 'package:mama_kris/features/appl/app_auth/domain/repositories/auth_repository.dart';

class LoginUsingCachedUsecase extends UsecaseWithoutParams<UserEntity> {
  final AuthRepository repository;

  LoginUsingCachedUsecase(this.repository);

  @override
  ResultFuture<UserEntity> call() async {
    return await repository.loginUsingCached();
  }
}
