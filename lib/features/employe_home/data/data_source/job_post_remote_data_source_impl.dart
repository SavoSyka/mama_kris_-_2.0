import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/auth/data/data_source/auth_local_data_source.dart';
import 'package:mama_kris/features/employe_home/data/data_source/job_post_remote_data_source.dart';
import 'package:mama_kris/features/employe_home/data/model/contact_model.dart';
import 'package:mama_kris/features/employe_home/data/model/employe_job_model.dart';
import 'package:mama_kris/features/employe_home/data/model/job_post_model.dart';
import 'package:mama_kris/features/employe_home/data/model/profession_model.dart';

class JobPostRemoteDataSourceImpl implements JobPostRemoteDataSource {
  final Dio dio;

  JobPostRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> postJob(JobPostModel jobPost) async {
    try {
      final response = await dio.post(
        ApiConstants.createJob("23737"),
        data: 
        // {
        //   "userID": 23737,
        //   "description": "Software Developer",
        //   "dateTime": "2023-10-01T12:00:00Z",
        //   "salary": 50000,
        //   "status": "checking",
        //   "title": "Senior Developer",
        //   "contactsID": 21106,
        //   "firstPublishedAt": "3",
        // },

        jobPost.toJson(),
      );

      debugPrint("Post job response: ${response.data}");
    } on DioException catch (e) {
      throw ApiException(
        message: _handleError(e),
        statusCode: e.response?.statusCode ?? 400,
      );
    }
  }

  @override
  Future<List<EmployeJobModel>> getAllPostedJob({required String type}) async {
    final userId = await getIt<AuthLocalDataSource>().getUserId();
    try {
      final response = await dio.get(
        ApiConstants.getUserJob(userId),
        queryParameters: {'type': type},
      );
      debugPrint("Post job response: ${response.data}");

      final responseData = response.data as List<dynamic>;

      final result = responseData
          .map((resp) => EmployeJobModel.fromJson(resp))
          .toList();

      return result;
    } on DioException catch (e) {
      throw ApiException(
        message: _handleError(e),
        statusCode: e.response?.statusCode ?? 400,
      );
    }
  }

  @override
  Future<List<ProfessionModel>> getProfessions() async {
    try {
      final response = await dio.get(ApiConstants.getProfessions);
      debugPrint("Get professions response: ${response.data}");

      final responseData = response.data as List<dynamic>;

      final result = responseData
          .map((resp) => ProfessionModel.fromJson(resp))
          .toList();

      return result;
    } on DioException catch (e) {
      throw ApiException(
        message: _handleError(e),
        statusCode: e.response?.statusCode ?? 400,
      );
    }
  }

  @override
  Future<List<ContactModel>> getContacts() async {
    try {
      final response = await dio.get(ApiConstants.getContacts);
      debugPrint("Get contacts response: ${response.data}");

      final responseData = response.data as List<dynamic>;

      final result = responseData
          .map((resp) => ContactModel.fromJson(resp))
          .toList();

      return result;
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
