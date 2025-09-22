import 'package:mama_kris/features/applicant_welcome/data/model/user_model.dart';
import 'package:mama_kris/features/employe_welcome/data/model/emp_user_model.dart';


abstract class EmpAuthRemoteDataSource {
  Future<bool> checkEmail(String email);
  Future<bool> forgotPassword(String email);

  Future<bool> validateOtp(String email, String otp);
  Future<EmpUserModel> register(String email, String name, String password);
  Future<EmpUserModel> login(String email, String password);
  Future<EmpUserModel> changePassword( String password);

}



