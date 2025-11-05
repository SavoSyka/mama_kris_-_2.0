import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';
import 'package:mama_kris/features/appl/appl_home/data/models/job_list_model.dart';
import 'package:mama_kris/features/appl/appl_home/data/models/job_model.dart';

abstract class JobRemoteDataSource {
  Future<JobListModel> fetchJobs();
  Future<JobListModel> searchJobs(String query);
  Future<void> likeJob(int jobId);
  Future<void> dislikeJob(int jobId);
}

class JobRemoteDataSourceImpl implements JobRemoteDataSource {
  final Dio dio;

  JobRemoteDataSourceImpl(this.dio);

  @override
  Future<JobListModel> fetchJobs() async {
    try {
      final queryParameters = {
        "excludeViewed": false,
        "pageSize": 3,
        "page": 1,
      };

      final userID = await sl<AuthLocalDataSource>().getUserId() ?? "";

      final response = await dio.get(
        ApiConstants.getRandomJobs(userID),
        queryParameters: queryParameters,
      );

      if (response.statusCode.toString().startsWith('2')) {
        debugPrint('${response.data['data']}');
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
        message: e.response?.data['message'] ?? 'Network error',
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
        message: e.response?.data['message'] ?? 'Network error',
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

      final response = await dio.put(
        ApiConstants.likeOrDislikeJob(userID, jobId.toString()),
        data: {"isLiked": true},
      );
    } catch (e) {
      debugPrint("erroro $e");
    }
  }

  @override
  Future<void> dislikeJob(int jobId) async {
    try {
      final userID = await sl<AuthLocalDataSource>().getUserId() ?? "";

      final response = await dio.put(
        ApiConstants.likeOrDislikeJob(userID, jobId.toString()),
        data: {"isLiked": false},
      );
    } catch (e) {
      debugPrint("erroro $e");
    }
  }
}
