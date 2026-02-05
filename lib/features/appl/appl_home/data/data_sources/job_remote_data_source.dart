import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';
import 'package:mama_kris/features/appl/appl_favorite/data/model/liked_list_job_model.dart';
import 'package:mama_kris/features/appl/appl_home/data/models/job_list_model.dart';

abstract class JobRemoteDataSource {
  Future<JobListModel> fetchJobs({required int page});
  Future<JobListModel> filterJobs({
    required int page,
    required int perPage,
    String? minSalary,
    String? maxSalary,
    String? title,
    bool? salaryWithAgreemen,
  });

  Future<JobListModel> searchJobs(String query);
  Future<void> likeJob(int jobId);
  Future<void> dislikeJob(int jobId);
  Future<void> viewJob(int jobId);
  Future<LikedJobListModel> fetchLikedJobs(int page);
}

class JobRemoteDataSourceImpl implements JobRemoteDataSource {
  final Dio dio;

  JobRemoteDataSourceImpl(this.dio);

  @override
  Future<JobListModel> fetchJobs({required int page}) async {
    try {
      final queryParameters = {
        "excludeViewed": false,
        "pageSize": 10,
        "page": page,
      };

      final userID = await sl<AuthLocalDataSource>().getUserId() ?? "";

      final response = await dio.get(
        ApiConstants.getRandomJobs(userID),
        queryParameters: queryParameters,
      );

      if (response.statusCode.toString().startsWith('2')) {
        final jobList = JobListModel.fromJson(response.data);
        // await sl<AuthLocalDataSource>().saveSubscription(true);

        return jobList;
      } else {
        throw ApiException(
          message: response.data['message'] ?? 'Login failed',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        message: _extractDioMessage(e),
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      debugPrint("erroro $e");
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<JobListModel> filterJobs({
    required int page,
    required int perPage,
    String? minSalary,
    String? maxSalary,
    String? title,
    bool? salaryWithAgreemen,
  }) async {
    try {
      final queryParameters = {
        "page": page,
        "pageSize": 10,
        if (title != null) 'titleQuery': title,
        if (title != null) 'description': title,

        if (minSalary != null) 'minSalary': minSalary,
        if (maxSalary != null) 'maxSalary': maxSalary,
        "excludeViewed": false,
      };

      final userID = await sl<AuthLocalDataSource>().getUserId() ?? "";

      final response = await dio.get(
        title != null ? 
        ApiConstants.getJobs(userID):
        ApiConstants.getRandomJobs(userID),

        queryParameters: queryParameters,
      );

      if (response.statusCode.toString().startsWith('2')) {
        final jobList = JobListModel.fromJson(response.data);

        return jobList;
      } else {
        throw ApiException(
          message: response.data['message'] ?? 'Login failed',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        message: _extractDioMessage(e),
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      debugPrint("erroro $e");
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<JobListModel> searchJobs(String query) async {
    try {
      final response = await dio.post(ApiConstants.login);

      if (response.statusCode.toString().startsWith('2')) {
        final jobList = JobListModel.fromJson(response.data);

        debugPrint("user succedd");
        return jobList;
      } else {
        throw ApiException(
          message: response.data['message'] ?? 'Login failed',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        message: _extractDioMessage(e),
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      debugPrint("erroro $e");
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<void> likeJob(int jobId) async {
    try {
      final userID = await sl<AuthLocalDataSource>().getUserId() ?? "";

      await dio.put(
        ApiConstants.likeOrDislikeJob(userID, jobId.toString()),
        data: {"isLiked": true, "isviewed": true},
      );
    } catch (e) {
      debugPrint("erroro $e");
    }
  }

  @override
  Future<void> dislikeJob(int jobId) async {
    try {
      final userID = await sl<AuthLocalDataSource>().getUserId() ?? "";

      await dio.put(
        ApiConstants.likeOrDislikeJob(userID, jobId.toString()),
        data: {"isLiked": false},
      );
    } catch (e) {
      debugPrint("erroro $e");
    }
  }

  @override
  Future<void> viewJob(int jobId) async {
    try {
      final userID = await sl<AuthLocalDataSource>().getUserId() ?? "";

      await dio.put(
        ApiConstants.likeOrDislikeJob(userID, jobId.toString()),
        data: {"isviewed": true},
      );
    } catch (e) {
      debugPrint("error viewing job $e");
    }
  }

  @override
  Future<LikedJobListModel> fetchLikedJobs(page) async {
    final queryParameters = {
      "excludeViewed": false,
      "pageSize": 10,
      "page": page,
    };

    final userId = await sl<AuthLocalDataSource>().getUserId() ?? "";
    final response = await dio.get(
      ApiConstants.getLikedJobs(userId),
      queryParameters: queryParameters,
    );

    if (response.statusCode == 200) {
      return LikedJobListModel.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch liked jobs');
    }
  }

  String _extractDioMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message']?.toString();
      if (message != null && message.isNotEmpty) return message;
      final error = data['error']?.toString();
      if (error != null && error.isNotEmpty) return error;
    } else if (data is String && data.isNotEmpty) {
      return data;
    }

    if (e.message != null && e.message!.isNotEmpty) {
      return e.message!;
    }

    return 'Network error';
  }
}
