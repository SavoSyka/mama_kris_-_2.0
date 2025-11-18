import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';
import 'package:mama_kris/features/emp/emp_resume/data/data_sources/resume_remote_data_source.dart';
import 'package:mama_kris/features/emp/emp_resume/data/models/resume_list_model.dart';

class ResumeRemoteDataSourceImpl implements ResumeRemoteDataSource {
  final Dio dio;

  ResumeRemoteDataSourceImpl(this.dio);

  @override
  Future<ResumeListModel> fetchUsers({
    required int page,
    required bool isFavorite,
  }) async {
    try {
      final queryParameters = {
        "excludeViewed": false,
        "pageSize": 10,
        "page": page,
      };

      final userID = await sl<AuthLocalDataSource>().getUserId() ?? "";

      final response = await dio.get(
        ApiConstants.getUsers,
        queryParameters: queryParameters,
      );

      if (response.statusCode.toString().startsWith('2')) {
        final userList = ResumeListModel.fromJson(response.data);

        return userList;
      } else {
        throw ApiException(
          message: response.data['message'] ?? 'Fetch users failed',
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
  Future<bool> updatedFavoriting({required String userId, required bool isFavorited}) async{
      try {
      final queryParameters = {
        "userId": userId,
        "isFavorited": isFavorited,
      };

      final userID = await sl<AuthLocalDataSource>().getUserId() ?? "";

      final response = await dio.get(
        ApiConstants.getUsers,
        queryParameters: queryParameters,
      );

      if (response.statusCode.toString().startsWith('2')) {
        final userList = ResumeListModel.fromJson(response.data);

        return true;
      } else {
        throw ApiException(
          message: response.data['message'] ?? 'Fetch users failed',
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
}
