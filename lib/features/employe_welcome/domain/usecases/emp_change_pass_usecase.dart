// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/employe_welcome/domain/entities/employe_user.dart';
import 'package:mama_kris/features/employe_welcome/domain/repository/employe_auth_repository.dart';


class EmpChangePassUsecase extends UsecaseWithParams<EmployeUser, ChangePassParams> {
  final EmployeAuthRepository repository;
  EmpChangePassUsecase(this.repository);

  @override
  ResultFuture<EmployeUser> call(ChangePassParams params) async {
    return await repository.changePassword(params.password);
  }
}

class ChangePassParams extends Equatable {
  final String password;

  const ChangePassParams({required this.password});

  @override
  List<Object?> get props => [password];

}
