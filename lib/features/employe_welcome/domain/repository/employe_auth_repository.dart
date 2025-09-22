import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/employe_welcome/domain/entities/employe_user.dart';

abstract class EmployeAuthRepository {
  ResultFuture<bool> checkEmail(String email);
  ResultFuture<bool> validateOtp(String email, String otp);
  ResultFuture<EmployeUser> register(String email, String name, String password);
  ResultFuture<EmployeUser> login(String email, String password);
  ResultFuture<EmployeUser> changePassword(String password);
  ResultFuture<bool> forgotPassword(String email);

}
