import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/employe_profile/data/data_source/profile_remote_data_source.dart';
import 'package:mama_kris/features/employe_profile/data/model/about_update_model.dart';
import 'package:mama_kris/features/employe_profile/data/model/contact_model.dart';
import 'package:mama_kris/features/employe_profile/data/model/email_update_model.dart';
import 'package:mama_kris/features/employe_profile/data/model/email_verification_model.dart';
import 'package:mama_kris/features/employe_profile/data/model/password_update_model.dart';
import 'package:mama_kris/features/employe_profile/domain/entity/about_update_entity.dart';
import 'package:mama_kris/features/employe_profile/domain/entity/contact_entity.dart';
import 'package:mama_kris/features/employe_profile/domain/entity/email_update_entity.dart';
import 'package:mama_kris/features/employe_profile/domain/entity/email_verification_entity.dart';
import 'package:mama_kris/features/employe_profile/domain/entity/password_update_entity.dart';
import 'package:mama_kris/features/employe_profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  ResultVoid updateEmail(EmailUpdateEntity emailUpdate) async {
    try {
      final model = EmailUpdateModel(email: emailUpdate.email);
      await remoteDataSource.updateEmail(model);
      return const Right(null);
    } on ApiException catch (err) {
      return Left(ServerFailure(err.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultVoid verifyEmail(EmailVerificationEntity emailVerification) async {
    try {
      final model = EmailVerificationModel(otp: emailVerification.otp);
      await remoteDataSource.verifyEmail(model);
      return const Right(null);
    } on ApiException catch (err) {
      return Left(ServerFailure(err.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultVoid updateContacts(ContactEntity contactUpdate) async {
    try {
      final contacts = ContactModel(
        whatsapp: contactUpdate.whatsapp,
        telegram: contactUpdate.telegram,
        vk: contactUpdate.vk,
      );

      await remoteDataSource.updateContacts(contacts);
      return const Right(null);
    } on ApiException catch (err) {
      return Left(ServerFailure(err.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultVoid updatePassword(PasswordUpdateEntity passwordUpdate) async {
    try {
      final model = PasswordUpdateModel(
        oldPassword: passwordUpdate.oldPassword,
        newPassword: passwordUpdate.newPassword,
      );
      await remoteDataSource.updatePassword(model);
      return const Right(null);
    } on ApiException catch (err) {
      return Left(ServerFailure(err.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultVoid updateAbout(AboutUpdateEntity aboutUpdate) async {
    try {
      final model = AboutUpdateModel(description: aboutUpdate.description);
      await remoteDataSource.updateAbout(model);
      return const Right(null);
    } on ApiException catch (err) {
      return Left(ServerFailure(err.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
