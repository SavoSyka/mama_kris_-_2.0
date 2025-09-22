// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/employe_welcome/domain/repository/employe_auth_repository.dart';


class EmpForgotPassUsecase extends UsecaseWithParams<bool, ForgotParams> {
  final EmployeAuthRepository repository;
  EmpForgotPassUsecase(this.repository);

  @override
  ResultFuture<bool> call(ForgotParams params) async {
    return await repository.forgotPassword(params.email);
  }
}

class ForgotParams extends Equatable {
  final String email;

  const ForgotParams({required this.email});

  @override
  List<Object?> get props => [email];
}
