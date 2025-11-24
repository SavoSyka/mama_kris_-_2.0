import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  ResultFuture<UserEntity> login(String email, String password);
  ResultFuture<UserEntity> signup(String name, String email, String password);
  ResultFuture<bool> checkEmail(String email);

  ResultFuture<bool> verifyOtp(String email, String otp);
  ResultFuture<bool> resendOtp(String email);
  ResultFuture<bool> forgotPassword(String email);
  ResultFuture<bool> updatePassword(String newPassword);

  ResultFuture<bool> loginWithGoogle({required String idToken});
  ResultFuture<UserEntity> loginWithApple({
    required String identityToken,
    required Map<String, dynamic> userData,
  });
}
