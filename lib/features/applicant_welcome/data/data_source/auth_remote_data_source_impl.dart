import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/features/applicant_welcome/data/data_source/auth_local_data_source.dart';
import 'package:mama_kris/features/applicant_welcome/data/model/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final AuthLocalDataSource local;

  AuthRemoteDataSourceImpl({required this.dio, required this.local});

  @override
  Future<bool> checkEmail(String email) async {
    try {
      final response = await dio.post(
        ApiConstants.checkEmail,
        data: {'email': email},
      );
      return true;
    } on DioException catch (e) {
      throw ApiException(message: _handleError(e), statusCode: 400);
    }
  }

  @override
  Future<bool> forgotPassword(String email) async {
    try {
      final response = await dio.post(
        ApiConstants.forgotPassword,
        data: {'email': email},
      );
      return true;
    } on DioException catch (e) {
      throw ApiException(message: _handleError(e), statusCode: 400);
    }
  }

  @override
  Future<bool> validateOtp(String email, String otp) async {
    try {
      final response = await dio.post(
        ApiConstants.validateCode,
        data: {'email': email, 'verificationCode': otp},
      );

      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String? ?? '';

      await local.saveToken(token);

      return true;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  @override
  Future<UserModel> register(String email, String name, String password) async {
    try {
      final response = await dio.post(
        ApiConstants.register,
        data: {'email': email, 'name': name, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;
      debugPrint('Login response: $data');

      final accessToken = data['accessToken'] as String? ?? '';
      final refreshToken = data['refreshToken'] as String? ?? '';

      await local.saveToken(accessToken);
      await local.saveRefreshToken(refreshToken);
      final user = UserModel(id: "id", email: "email", name: "name");

      return user;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;
      debugPrint('Login response: $data');

      final accessToken = data['accessToken'] as String? ?? '';
      final refreshToken = data['refreshToken'] as String? ?? '';
      final userId = data['userId'].toString();

      await local.saveUserType(true);
      await local.saveToken(accessToken);
      await local.saveRefreshToken(refreshToken);
      await local.saveUserId(userId);

      final user = UserModel(id: "id", email: "email", name: "name");

      return user;
      // Return UserModel
      // return UserModel.fromJson(userJson);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  @override
  Future<UserModel> changePassword(String password) async {
    try {
      final response = await dio.post(
        ApiConstants.changePassword,
        data: {'newPassword': password},
      );

      final data = response.data as Map<String, dynamic>;
      debugPrint('Login response: $data');

      final accessToken = data['accessToken'] as String? ?? '';
      final refreshToken = data['refreshToken'] as String? ?? '';

      await local.saveToken(accessToken);
      await local.saveRefreshToken(refreshToken);

      final user = UserModel(id: "id", email: "email", name: "name");

      return user;
      // Return UserModel
      // return UserModel.fromJson(userJson);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
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
