import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';

abstract class LifeCycleManagerDataSource {
  Future<int> userEntered(String startDate);
  Future<void> userLeft(String endDate, int sessionId);
}

class LifeCycleManagerDataSourceImpl extends LifeCycleManagerDataSource {
  LifeCycleManagerDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<int> userEntered(String startDate) async {
    try {
      final userId = await sl<AuthLocalDataSource>().getUserId() ?? "";

      final postData = {"startTime": startDate, "userId": userId};

      final response = await dio.post(
        ApiConstants.userEnterSession(userId),
        data: postData,
        // options: Options(headers: {...dio.options.headers, ...requestHeaders}),
      );

      if (response.statusCode.toString().startsWith('2')) {
        final data = response.data as Map<String, dynamic>;
        debugPrint('Login response: $data');
        final sessionId = data['sessionID'] as int;
        return sessionId;
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
  Future<void> userLeft(String endDate, int sessionId) async {
    try {
      final userId = await sl<AuthLocalDataSource>().getUserId() ?? "";
      final postData = {
         "endTime": endDate
        // "endTime": endDate, 'userId': userId}
      };

      final response = await dio.put(
        ApiConstants.userLeftSession(userId, sessionId.toString()),
        data: postData,
        // options: Options(headers: {...dio.options.headers, ...requestHeaders}),
      );

      if (response.statusCode.toString().startsWith('2')) {
        final data = response.data as Map<String, dynamic>;
        debugPrint('Login response: $data');
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
}
