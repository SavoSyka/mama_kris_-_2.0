import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';
import 'package:mama_kris/features/appl/app_auth/data/models/user_profile_model.dart';
import 'package:mama_kris/features/appl/applicant_contact/data/data_source/applicant_contact_data_source.dart';
import 'package:mama_kris/features/appl/applicant_contact/data/model/applicant_contact_model.dart';
import 'package:mama_kris/features/emp/employe_contact/data/data_source/employee_contact_data_source.dart';
import 'package:mama_kris/features/emp/employe_contact/data/model/employee_contact_model.dart';
import 'package:uuid/uuid.dart';

/// Mock implementation of ApplicantContactDataSource for testing and development.
/// Uses in-memory storage to simulate API operations.
class EmployeeContactDataSourceImpl implements EmployeeContactDataSource {
  final Dio dio;

  EmployeeContactDataSourceImpl({required this.dio});

  @override
  Future<EmployeeContactModel> createContact(
    EmployeeContactModel contact,
  ) async {
    try {
      debugPrint("contact to create ${contact.toJson()}");
      final postData = contact.toJson();

      final userId = await sl<AuthLocalDataSource>().getUserId() ?? "";
      final response = await dio.post(
        ApiConstants.createContact(userId),
        data: postData,
      );

      if (response.statusCode.toString().startsWith('2')) {
        final json = response.data;
        return EmployeeContactModel.fromJson(json);
      } else {
        throw ApiException(
          message: response.statusMessage,
          statusCode: response.statusCode ?? 400,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<EmployeeContactModel> updateContact(
    String id,
    EmployeeContactModel contact,
  ) async {
    try {
      final postData = contact.toJson();
      final userId = await sl<AuthLocalDataSource>().getUserId() ?? "";

      final response = await dio.put(
        ApiConstants.updateContact(userId, id),
        data: postData,
      );

      if (response.statusCode.toString().startsWith('2')) {
        final json = response.data;
        return EmployeeContactModel.fromJson(json);
      } else {
        throw ApiException(
          message: response.statusMessage,
          statusCode: response.statusCode ?? 400,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<bool> deleteContact(String id) async {
    try {
      final userId = await sl<AuthLocalDataSource>().getUserId() ?? "";

      final response = await dio.delete(ApiConstants.deleteContact(userId, id));

      if (response.statusCode.toString().startsWith('2')) {
        debugPrint("Contact is deleted");
        return true;
      } else {
        throw ApiException(
          message: response.statusMessage,
          statusCode: response.statusCode ?? 400,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<EmployeeContactModel?> getContact(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    return const EmployeeContactModel(
      userId: 0,
      contactId: 0,

      name: "contact.name,",
      email: " contact.email",
      phone: "contact.phone",
      telegram: "",
      whatsapp: '',
      vk: '',
    );
  }

  @override
  Future<List<EmployeeContactModel>> getAllContacts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      const EmployeeContactModel(
        userId: 0,
        contactId: 0,
        name: "contact.name,",
        email: " contact.email",
        phone: "contact.phone",
        telegram: "",
        whatsapp: '',
        vk: '',
      ),
    ];
  }

  @override
  Future<bool> updateExperience(List<WorkExperienceModel> experience) async {
    try {
      final userId = await sl<AuthLocalDataSource>().getUserId() ?? "";

      final List<Map<String, dynamic>> experienceJson = experience
          .map((e) => e.toJson())
          .toList();

      final response = await dio.put(
        ApiConstants.updateUser(userId),
        data: {"workExperience": experienceJson},
      );

      if (response.statusCode.toString().startsWith('2')) {
        debugPrint("Experience updated");
        return true;
      } else {
        throw ApiException(
          message: response.statusMessage,
          statusCode: response.statusCode ?? 400,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<bool> deleteUserAccount() async {
    try {
      final userId = await sl<AuthLocalDataSource>().getUserId() ?? "";

      final response = await dio.delete(ApiConstants.deleteUserAcct(userId));

      if (response.statusCode.toString().startsWith('2')) {
        debugPrint("Contact is deleted");
        return true;
      } else {
        throw ApiException(
          message: response.statusMessage,
          statusCode: response.statusCode ?? 400,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<bool> updateBasicInfo({
    required String name,
    required String dob,
  }) async {
    try {
      final userId = await sl<AuthLocalDataSource>().getUserId() ?? "";

      // final queryParams = {"name": " robby three", "birthDate": "2009-11-01"};

      final postData = {"name": name, "birthDate": dob};

      debugPrint("Query params $postData");

      final response = await dio.put(
        ApiConstants.updateUser(userId),
        data: postData,
      );

      if (response.statusCode.toString().startsWith('2')) {
        debugPrint("Contact is deleted");
        return true;
      } else {
        throw ApiException(
          message: response.statusMessage,
          statusCode: response.statusCode ?? 400,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<bool> logout() async {
    await sl<AuthLocalDataSource>().clearAll();

    return true;
  }
}
