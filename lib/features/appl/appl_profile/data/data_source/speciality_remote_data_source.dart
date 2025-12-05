import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';

abstract class SpecialityRemoteDataSource {
  Future<List<String>> getSpeciality(String query);
}

class SpecialityRemoteDataSourceImpl extends SpecialityRemoteDataSource {
  final Dio dio;

  SpecialityRemoteDataSourceImpl({required this.dio})
  
  @override
  Future<List<String>> getSpeciality(String query) async {
    try {
      final userId = await sl<AuthLocalDataSource>().getUserId() ?? "";

      final postData = {"query": query, "userId": userId};

      final response = await dio.post(
        ApiConstants.userEnterSession(userId),
        data: postData,
        // options: Options(headers: {...dio.options.headers, ...requestHeaders}),
      );

      if (response.statusCode.toString().startsWith('2')) {
        final data = response.data as Map<String, dynamic>;
        debugPrint('Login response: $data');
        return [];
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

