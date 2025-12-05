import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/core/utils/get_platform_type.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_remote_data_source.dart';
import 'package:mama_kris/features/appl/app_auth/data/models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final AuthLocalDataSource local;

  AuthRemoteDataSourceImpl(this.dio, this.local);

  @override
  ResultFuture<UserModel> login(String email, String password) async {
    try {
      final postData = {
        'email': email,
        'password': password,
        'HaveVacancies': false,
      };
      final response = await dio.post(ApiConstants.login, data: postData);

      if (response.statusCode.toString().startsWith('2')) {
        final data = response.data as Map<String, dynamic>;
        debugPrint('Login response: $data');

        final user = UserModel.fromJson(data);

        final accessToken = user.accessToken;
        final refreshToken = user.refreshToken;
        final userId = user.userId.toString();

        final isActive = user.subscription.active;

        await local.saveUserType(true);
        await local.saveToken(accessToken);
        await local.saveRefreshToken(refreshToken);
        await local.saveUserId(userId);
        await local.saveSubscription(isActive);

        // Save full user data for persistent login
        await local.saveUser(data['user']);

        return Right(user);
      } else {
        throw ApiException(
          message: response.data['message'] ?? 'Login failed',
          statusCode: response.statusCode ?? 400,
        );
      }
    } on ApiException {
      rethrow;
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
        data: {
          'name': name,
          'email': email,
          'password': password,
          "LookingForJob": 'Looking for job',
        },
      );

      if (response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        debugPrint('Login response: $data');

        final user = UserModel.fromJson(data);

        final accessToken = user.accessToken;
        final refreshToken = user.refreshToken;
        final userId = user.userId.toString();

        await local.saveUserType(true);
        await local.saveToken(accessToken);
        await local.saveRefreshToken(refreshToken);
        await local.saveUserId(userId);

        // Save full user data for persistent login
        await local.saveUser(data['user']);

        return Right(user);
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
        final data = response.data as Map<String, dynamic>;
        final token = data['token'] as String? ?? '';

        await local.saveToken(token);

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
        ApiConstants.resendOtp, // Assuming resend uses same endpoint
        data: {'email': email},
      );

      if (response.statusCode.toString().startsWith('2')) {
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

      if (response.statusCode.toString().startsWith('2')) {
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

  @override
  Future<bool> loginWithGoogle({required String idToken}) async {
    try {
      // Platform-specific header
      final Map<String, dynamic> requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'provider': platformType,
      };

      final response = await dio.post(
        ApiConstants.loginWIthGoogle,
        data: {'idToken': idToken},
        options: Options(headers: {...dio.options.headers, ...requestHeaders}),
      );

      if (response.statusCode == 200) {
        debugPrint("Response from API for Google login: ${response.data}");
        return true;
      } else {
        throw const ApiException(
          message: 'Login with Google failed',
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
  Future<bool> updatePassword(String newPassword) async {
    try {
      final response = await dio.post(
        ApiConstants.updatePassword,
        data: {'newPassword': newPassword},
      );

      if (response.statusCode.toString().startsWith('2')) {
        return true;
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

  @override
  Future<UserModel> loginWithApple({
    required String identityToken,
    required Map<String, dynamic> userData,
  }) async {
    try {
      // Platform-specific header
      // final Map<String, dynamic> requestHeaders = {
      //   'Content-Type': 'application/json',
      //   'Accept': '*/*',
      //   'provider': platformType,
      // };

      final postData = {"identityToken": identityToken, "userData": userData};

      final response = await dio.post(
        ApiConstants.loginWithApple,
        data: postData,
        // options: Options(headers: {...dio.options.headers, ...requestHeaders}),
      );

      if (response.statusCode.toString().startsWith('2')) {
        final data = response.data as Map<String, dynamic>;
        debugPrint('Login response: $data');

        final user = UserModel.fromJson(data);

        final accessToken = user.accessToken;
        final refreshToken = user.refreshToken;
        final userId = user.userId.toString();

        await local.saveUserType(true);
        await local.saveToken(accessToken);
        await local.saveRefreshToken(refreshToken);
        await local.saveUserId(userId);

        // Save full user data for persistent login
        await local.saveUser(data['user']);

        return user;
      } else {
        throw const ApiException(
          message: 'Login with Google failed',
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
  Future<UserModel> loginUsingCached() async {
    try {
      final userId = await sl<AuthLocalDataSource>().getUserId() ?? "";
      final response = await dio.get(ApiConstants.getUserFromCached(userId));

      if (response.statusCode.toString().startsWith('2')) {
        final data = response.data as Map<String, dynamic>;
        debugPrint('Login response: $data');

        final user = UserModel.fromJson(data);
        final isActive = user.subscription.active;

        await local.saveUserType(true);

        await local.saveUserId(userId);
        await local.saveSubscription(isActive);

        // Save full user data for persistent login
        await local.saveUser(data['user']);
        return user;
      } else {
        throw ApiException(
          message: response.data['message'] ?? 'Login failed',
          statusCode: response.statusCode ?? 400,
        );
      }
    } on ApiException {
      rethrow;
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
}
