import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/app_auth/data/models/user_model.dart';
import 'package:mama_kris/features/emp/emp_auth/data/models/emp_user_model.dart';

abstract class EmpAuthRemoteDataSource {
  ResultFuture<EmpUserModel> login(String email, String password);
  ResultFuture<EmpUserModel> signup(String name, String email, String password);
  ResultFuture<bool> verifyOtp(String email, String otp);
  ResultFuture<bool> checkEmail(String email, bool isSubscribe);

  ResultFuture<bool> resendOtp(String email);
  ResultFuture<bool> forgotPassword(String email);
  Future<bool> loginWithGoogle({required String idToken});
  Future<bool> updatePassword(String newPassword);

  Future<EmpUserModel> loginWithApple({
    required String identityToken,
    required Map<String, dynamic> userData,
  });

  Future<EmpUserModel> loginUsingCached();

}
