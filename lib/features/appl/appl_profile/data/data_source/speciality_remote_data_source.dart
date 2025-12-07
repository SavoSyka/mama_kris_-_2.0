import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';

abstract class SpecialityRemoteDataSource {
  Future<List<String>> searchSpeciality(String query);
}

class SpecialityRemoteDataSourceImpl extends SpecialityRemoteDataSource {
  final Dio dio;

  SpecialityRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<String>> searchSpeciality(String query) async {
    try {
      final queryParams = {'page': 1, "pageSize": 40, "query": query};
      final response = await dio.get(
        ApiConstants.getSpeciality,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;
        debugPrint("Speciality Searched 😌");
        final returnData = data.map((json) => json.toString()).toList();
        return returnData;
      } else {
        debugPrint("Speciality Error 😌");

        throw ApiException(
          message: response.data['message'] ?? 'Failed to search specialities',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      debugPrint("Speciality Error 😌 $e");

      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}
