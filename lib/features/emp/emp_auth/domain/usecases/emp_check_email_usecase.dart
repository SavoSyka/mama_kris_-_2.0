// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/repositories/auth_repository.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/repositories/emp_auth_repository.dart';

class CheckEmailParams {
  final String email;
  final bool isSubscibe;

  const CheckEmailParams({
    required this.email,
    required this.isSubscibe,
  });
}

class EmpCheckEmailUsecase extends UseCase<bool, CheckEmailParams> {
  final EmpAuthRepository repository;

  EmpCheckEmailUsecase(this.repository);

  @override
  ResultFuture<bool> call(CheckEmailParams params) async {
    return await repository.checkEmail(params.email, params.isSubscibe);
  }
}
