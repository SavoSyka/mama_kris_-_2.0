// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/applicant_welcome/domain/repository/auth_repository.dart';
import 'package:mama_kris/features/employe_welcome/domain/repository/employe_auth_repository.dart';

import '../entities/employe_user.dart';

class EmpRegisterUsecase
    extends UsecaseWithParams<EmployeUser, RegisterParams> {
  final EmployeAuthRepository repository;
  EmpRegisterUsecase(this.repository);

  @override
  ResultFuture<EmployeUser> call(RegisterParams params) async {
    return await repository.register(
      params.email,
      params.name,
      params.password,
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String name;

  final String password;
  const RegisterParams({
    required this.email,
    required this.name,
    required this.password,
  });

  @override
  List<Object?> get props => [email, name, password];
}
