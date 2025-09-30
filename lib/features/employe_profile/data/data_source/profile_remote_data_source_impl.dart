import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/auth/data/data_source/auth_local_data_source.dart';
import 'package:mama_kris/features/employe_profile/data/data_source/profile_remote_data_source.dart';
import 'package:mama_kris/features/employe_profile/data/model/about_update_model.dart';
import 'package:mama_kris/features/employe_profile/data/model/contact_model.dart';
import 'package:mama_kris/features/employe_profile/data/model/email_update_model.dart';
import 'package:mama_kris/features/employe_profile/data/model/email_verification_model.dart';
import 'package:mama_kris/features/employe_profile/data/model/password_update_model.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> updateEmail(EmailUpdateModel emailUpdate) async {
    try {
      final response = await dio.put(
        'user/email', // TODO: Add to ApiConstants
        data: emailUpdate.toJson(),
      );
      debugPrint("Update email response: ${response.data}");
    } on DioException catch (e) {
      throw ApiException(
        message: _handleError(e),
        statusCode: e.response?.statusCode ?? 400,
      );
    }
  }

  @override
  Future<void> verifyEmail(EmailVerificationModel emailVerification) async {
    try {
      final response = await dio.post(
        'user/verify-email', // TODO: Add to ApiConstants
        data: emailVerification.toJson(),
      );
      debugPrint("Verify email response: ${response.data}");
    } on DioException catch (e) {
      throw ApiException(
        message: _handleError(e),
        statusCode: e.response?.statusCode ?? 400,
      );
    }
  }

  @override
  Future<void> updateContacts(ContactModel contactUpdate) async {
    try {
      final userId = await getIt<AuthLocalDataSource>().getUserId();

      final putData = {
        "name": "Robera Insarmu",
        "telegram": "@robby",
        "email": "robby@example.com",
        "phone": "+1234567890",
        "whatsapp": "+1234567890",
        "vk": "robvk.com/example",
        "link": "https://examplerob.com",
      };

      final response = await dio.put(
        ApiConstants.updateContacts(userId, '21106'),
        data:
        //  putData,
        contactUpdate.toJson(),
      );
      debugPrint("Update contacts response: ${response.data}");
    } on DioException catch (e) {
      throw ApiException(
        message: _handleError(e),
        statusCode: e.response?.statusCode ?? 400,
      );
    }
  }

  @override
  Future<void> updatePassword(PasswordUpdateModel passwordUpdate) async {
    try {
      final response = await dio.put(
        'user/password', // TODO: Add to ApiConstants
        data: passwordUpdate.toJson(),
      );
      debugPrint("Update password response: ${response.data}");
    } on DioException catch (e) {
      throw ApiException(
        message: _handleError(e),
        statusCode: e.response?.statusCode ?? 400,
      );
    }
  }

  @override
  Future<void> updateAbout(AboutUpdateModel aboutUpdate) async {
    try {
      final response = await dio.put(
        'user/about', // TODO: Add to ApiConstants
        data: aboutUpdate.toJson(),
      );
      debugPrint("Update about response: ${response.data}");
    } on DioException catch (e) {
      throw ApiException(
        message: _handleError(e),
        statusCode: e.response?.statusCode ?? 400,
      );
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      return e.response?.data['message']?.toString() ?? 'Server error';
    } else {
      return e.message ?? 'Unexpected error';
    }
  }
}
