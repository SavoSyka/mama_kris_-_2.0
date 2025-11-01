import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_remote_data_source.dart';
import 'package:mama_kris/features/appl/app_auth/data/models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  ResultFuture<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode.toString().startsWith('2')) {
        final userModel = UserModel.fromJson(response.data);
        debugPrint("user succedd");
        return Right(userModel);
      } else {
        throw ApiException(
          message: response.data['message'] ?? 'Login failed',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      debugPrint("erroro $e");
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  ResultFuture<UserModel> signup(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await dio.post(
        ApiConstants.register,
        data: {'name': name, 'email': email, 'password': password},
      );

      if (response.statusCode == 201) {
        final userModel = UserModel.fromJson(response.data['user']);
        return Right(userModel);
      } else {
        throw ApiException(
          message: response.data['message'] ?? 'Signup failed',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  ResultFuture<bool> checkEmail(String email) async {
    try {
      final response = await dio.post(
        ApiConstants.checkEmail,
        data: {'email': email},
      );

      if (response.statusCode == 201) {
        return const Right(true);
      } else {
        throw const ApiException(
          message: "Invalid Email address11",
          statusCode: 500,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  ResultFuture<bool> verifyOtp(String email, String otp) async {
    try {
      final response = await dio.post(
        ApiConstants.validateCode,
        data: {'email': email, 'verificationCode': otp},
      );

      if (response.statusCode.toString().startsWith('2')) {
        return const Right(true);
      } else {
        throw const ApiException(
          message: 'OTP verification failed',
          statusCode: 500,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  ResultFuture<bool> resendOtp(String email) async {
    try {
      final response = await dio.post(
        ApiConstants.validateCode, // Assuming resend uses same endpoint
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        throw const ApiException(message: 'Resend OTP failed', statusCode: 500);
      }
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  ResultFuture<bool> forgotPassword(String email) async {
    try {
      final response = await dio.post(
        ApiConstants.forgotPassword,
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        throw const ApiException(
          message: 'Forgot password failed',
          statusCode: 500,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}
