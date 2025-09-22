// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/employe_welcome/domain/repository/employe_auth_repository.dart';


class EmpCheckEmailUsecase extends UsecaseWithParams<bool, CheckEmailParams> {
  final EmployeAuthRepository repository;
  EmpCheckEmailUsecase(this.repository);

  @override
  ResultFuture<bool> call(CheckEmailParams params) async {
    return await repository.checkEmail(params.email);
  }
}

class CheckEmailParams extends Equatable {
  final String email;

  const CheckEmailParams({required this.email});

  @override
  List<Object?> get props => [email];

}
