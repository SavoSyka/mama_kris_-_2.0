import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/auth/domain/repository/auth_repository.dart';

import '../entities/user.dart';

class LoginApplicant {
  final AuthRepository repository;
  LoginApplicant(this.repository);

  ResultFuture<User> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
