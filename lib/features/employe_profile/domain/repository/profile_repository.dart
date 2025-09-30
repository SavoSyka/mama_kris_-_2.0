import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/employe_profile/domain/entity/about_update_entity.dart';
import 'package:mama_kris/features/employe_profile/domain/entity/contact_entity.dart';
import 'package:mama_kris/features/employe_profile/domain/entity/email_update_entity.dart';
import 'package:mama_kris/features/employe_profile/domain/entity/email_verification_entity.dart';
import 'package:mama_kris/features/employe_profile/domain/entity/password_update_entity.dart';

abstract class ProfileRepository {
  ResultVoid updateEmail(EmailUpdateEntity emailUpdate);
  ResultVoid verifyEmail(EmailVerificationEntity emailVerification);
  ResultVoid updateContacts(ContactEntity contactUpdate);
  ResultVoid updatePassword(PasswordUpdateEntity passwordUpdate);
  ResultVoid updateAbout(AboutUpdateEntity aboutUpdate);
}