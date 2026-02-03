import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/features/emp/emp_resume/data/data_sources/speciality_remote_data_source.dart';
import 'package:mama_kris/features/emp/emp_resume/data/models/Speciality_list_model.dart';

class SpecialityRemoteDataSourceImpl implements SpecialityRemoteDataSource {
  final Dio dio;

  SpecialityRemoteDataSourceImpl(this.dio);

  @override
  Future<SpecialityListModel> searchSpecialities(String query, int page) async {
    try {
      final queryParams = {'page': page, "pageSize": 20, "query": query};
      final response = await dio.get(
        ApiConstants.getSpeciality,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final returnData = SpecialityListModel.fromJson(data);
        debugPrint("Speciality Searched 😌");
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
