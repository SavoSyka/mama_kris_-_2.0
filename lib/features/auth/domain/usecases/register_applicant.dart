import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/auth/domain/repository/auth_repository.dart';

import '../entities/user.dart';

class RegisterApplicant {
  final AuthRepository repository;
  RegisterApplicant(this.repository);

  ResultFuture<User> call(String email, String name, String password, {required bool isApplicant}) async {
    return await repository.register(email, name, password, isApplicant: isApplicant);
  }
}
