// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/applicant_welcome/domain/repository/auth_repository.dart';
import 'package:mama_kris/features/employe_welcome/domain/repository/employe_auth_repository.dart';

import '../entities/employe_user.dart';

class EmpLoginUsecase extends UsecaseWithParams<EmployeUser, LoginParams> {
  final EmployeAuthRepository repository;
  EmpLoginUsecase(this.repository);

  @override
  ResultFuture<EmployeUser> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;
  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
