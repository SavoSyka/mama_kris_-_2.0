import 'package:mama_kris/features/employe_profile/data/model/about_update_model.dart';
import 'package:mama_kris/features/employe_profile/data/model/contact_model.dart';
import 'package:mama_kris/features/employe_profile/data/model/email_update_model.dart';
import 'package:mama_kris/features/employe_profile/data/model/email_verification_model.dart';
import 'package:mama_kris/features/employe_profile/data/model/password_update_model.dart';

abstract class ProfileRemoteDataSource {
  Future<void> updateEmail(EmailUpdateModel emailUpdate);
  Future<void> verifyEmail(EmailVerificationModel emailVerification);
  Future<void> updateContacts(ContactModel contactUpdate);
  Future<void> updatePassword(PasswordUpdateModel passwordUpdate);
  Future<void> updateAbout(AboutUpdateModel aboutUpdate);
}