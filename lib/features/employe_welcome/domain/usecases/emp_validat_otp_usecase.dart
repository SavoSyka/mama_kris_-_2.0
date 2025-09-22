// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/employe_welcome/domain/repository/employe_auth_repository.dart';


class EmpValidatOtpUsecase extends UsecaseWithParams<bool, ValidateOtpParams> {
  final EmployeAuthRepository repository;
  EmpValidatOtpUsecase(this.repository);

  @override
  ResultFuture<bool> call(ValidateOtpParams params) async {
    return await repository.validateOtp(params.email, params.otp);
  }
}

class ValidateOtpParams extends Equatable {
  final String email;
  final String otp;


  const ValidateOtpParams({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
  
}
