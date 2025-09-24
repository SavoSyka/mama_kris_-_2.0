import 'package:mama_kris/features/auth/data/model/user_model.dart';


abstract class AuthRemoteDataSource {
  Future<bool> checkEmail(String email);
  Future<bool> forgotPassword(String email);

  Future<bool> validateOtp(String email, String otp);
  Future<UserModel> register(String email, String name, String password, {required bool isApplicant});
  Future<UserModel> login(String email, String password);
  Future<UserModel> changePassword( String password);

}



