import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/applicant_welcome/domain/entities/user.dart';

abstract class AuthRepository {
  ResultFuture<bool> checkEmail(String email);
  ResultFuture<bool> validateOtp(String email, String otp);
  ResultFuture<User> register(String email, String name, String password);
  ResultFuture<User> login(String email, String password);
  ResultFuture<User> changePassword(String password);
  ResultFuture<bool> forgotPassword(String email);

}
