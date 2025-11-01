import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/app_auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  ResultFuture<UserModel> login(String email, String password);
  ResultFuture<UserModel> signup(String name, String email, String password);
  ResultFuture<bool> verifyOtp(String email, String otp);
  ResultFuture<bool> checkEmail(String email, );

  ResultFuture<bool> resendOtp(String email);
  ResultFuture<bool> forgotPassword(String email);
}