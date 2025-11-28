import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/app_auth/data/models/user_profile_model.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/appl/applicant_contact/data/data_source/applicant_contact_data_source.dart';
import 'package:mama_kris/features/appl/applicant_contact/data/model/applicant_contact_model.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/entity/applicant_contact.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/repository/applicant_contact_repository.dart';

/// Implementation of ApplicantContactRepository.
/// Handles data operations and error handling between domain and data layers.
class ApplicantContactRepositoryImpl implements ApplicantContactRepository {
  final ApplicantContactDataSource _dataSource;

  ApplicantContactRepositoryImpl(this._dataSource);

  @override
  ResultFuture<ApplicantContact> createContact(ApplicantContact contact) async {
    try {
      final model = ApplicantContactModel.fromEntity(contact);
      final result = await _dataSource.createContact(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<ApplicantContact> updateContact(
    String id,
    ApplicantContact contact,
  ) async {
    try {
      final model = ApplicantContactModel.fromEntity(contact);
      final result = await _dataSource.updateContact(id, model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<bool> deleteContact(String id) async {
    try {
      final result = await _dataSource.deleteContact(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<ApplicantContact?> getContact(String id) async {
    try {
      final result = await _dataSource.getContact(id);
      return Right(result?.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<List<ApplicantContact>> getAllContacts() async {
    try {
      final result = await _dataSource.getAllContacts();
      final entities = result.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<bool> updateExperience(
    List<ApplWorkExperienceEntity> experience,
  ) async {
    try {
      final model = experience
          .map((exp) => WorkExperienceModel.fromEntity(exp))
          .toList();

      final result = await _dataSource.updateExperience(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<bool> deleteUserAccount() async {
    try {
      final result = await _dataSource.deleteUserAccount();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<bool> updateBasicInfo({
    required String name,
    required String dob,
  }) async {
    try {
      final result = await _dataSource.updateBasicInfo(name: name, dob: dob);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  ResultFuture<bool> logout() async {
    try {
      final result = await _dataSource.logout();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  



    @override
  ResultFuture<bool> addSpeciality(List<String> speciality)async {
    try {
      final result = await _dataSource.addSpeciality(speciality);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
