import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';
import 'package:mama_kris/features/emp/emp_home/data/data_sources/emp_job_remote_data_source.dart';
import 'package:mama_kris/features/emp/emp_home/data/models/create_job_request_model.dart';
import 'package:mama_kris/features/emp/emp_home/data/models/emp_job_list_model.dart';

class EmpJobRemoteDataSourceImpl implements EmpJobRemoteDataSource {
  final Dio dio;

  EmpJobRemoteDataSourceImpl(this.dio);

  @override
  Future<void> createJob(CreateJobRequestModel request) async {
    try {
      final userID = await sl<AuthLocalDataSource>().getUserId() ?? "";

      final response = await dio.post(
        ApiConstants.createJob(userID),

        data: request.toJson(),
      );

      if (response.statusCode.toString().startsWith('2')) {
        // Success
      } else {
        throw ApiException(
          message: response.data['message'] ?? 'Create job failed',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      debugPrint("error $e");
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<EmpJobListModel> fetchJobs({
    required String status,
    int page = 1,
  }) async {
    try {
      final userID = await sl<AuthLocalDataSource>().getUserId() ?? "";

      final queryParameters = {
        "page": page,
        "pageSize": 10,
        "statuses": status,
      };

      final response = await dio.get(
        ApiConstants.getUserJob(userID),
        queryParameters: queryParameters,
      );

      if (response.statusCode.toString().startsWith('2')) {
        debugPrint("Fetched job ${response.data}");
        final jobList = EmpJobListModel.fromJson(response.data);
        return jobList;
      } else {
        throw ApiException(
          message: response.data['message'] ?? 'Fetch jobs failed',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      debugPrint("error $e");
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}
