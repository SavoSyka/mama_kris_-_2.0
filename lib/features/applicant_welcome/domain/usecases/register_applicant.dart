import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/applicant_welcome/domain/repository/auth_repository.dart';

import '../entities/user.dart';

class RegisterApplicant {
  final AuthRepository repository;
  RegisterApplicant(this.repository);

  ResultFuture<User> call(String email, String name, String password) async {
    return await repository.register(email, name, password);
  }
}
