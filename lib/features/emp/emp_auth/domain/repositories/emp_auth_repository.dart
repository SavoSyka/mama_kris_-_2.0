import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_entity.dart';

abstract class EmpAuthRepository {
  ResultFuture<EmpUserEntity> login(String email, String password);
  ResultFuture<EmpUserEntity> signup(
    String name,
    String email,
    String password,
  );
  ResultFuture<bool> checkEmail(String email);

  ResultFuture<bool> verifyOtp(String email, String otp);
  ResultFuture<bool> resendOtp(String email);
  ResultFuture<bool> forgotPassword(String email);
  ResultFuture<bool> updatePassword(String newPassword);

  ResultFuture<bool> loginWithGoogle({required String idToken});

    ResultFuture<EmpUserEntity> loginWithApple({
    required String identityToken,
    required Map<String, dynamic> userData,
  });
}
