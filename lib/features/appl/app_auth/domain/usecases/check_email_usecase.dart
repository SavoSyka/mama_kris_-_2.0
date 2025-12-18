// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/repositories/auth_repository.dart';

class CheckEmailParams {
  final String email;
  final bool isSubscribe;

  const CheckEmailParams({required this.email, required this.isSubscribe});
}

class CheckEmailUsecase extends UseCase<bool, CheckEmailParams> {
  final AuthRepository repository;

  CheckEmailUsecase(this.repository);

  @override
  ResultFuture<bool> call(CheckEmailParams params) async {
    return await repository.checkEmail(params.email, params.isSubscribe);
  }
}
