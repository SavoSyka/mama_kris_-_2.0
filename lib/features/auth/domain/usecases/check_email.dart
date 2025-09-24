
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/auth/domain/repository/auth_repository.dart';

class CheckEmail {
  final AuthRepository repository;
  CheckEmail(this.repository);

  ResultFuture<bool> call(String email) async {
    return await repository.checkEmail(email);
  }
}
