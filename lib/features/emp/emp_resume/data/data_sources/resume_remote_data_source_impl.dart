import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';
import 'package:mama_kris/features/appl/app_auth/data/models/user_profile_model.dart';
import 'package:mama_kris/features/emp/emp_resume/data/data_sources/resume_remote_data_source.dart';
import 'package:mama_kris/features/emp/emp_resume/data/models/resume_list_model.dart';

class ResumeRemoteDataSourceImpl implements ResumeRemoteDataSource {
  final Dio dio;

  ResumeRemoteDataSourceImpl(this.dio);

  @override
  Future<ResumeListModel> fetchUsers({
    required int page,
    String? searchQuery,
  }) async {
    try {
      final queryParameters = {
        "excludeViewed": false,
        "pageSize": 10,
        "page": page,
        'q': searchQuery,
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
  Future<ResumeListModel> fetchFavoritedUsers({
    required int page,
    String? searchQuery,
  }) async {
    try {
      final queryParameters = {
        "excludeViewed": false,
        "pageSize": 10,
        "page": page,
        'q': searchQuery,
      };

      final response = await dio.get(
        ApiConstants.favoriteProfiles,

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
  Future<bool> updatedFavoriting({
    required String userId,
    required bool isFavorited,
  }) async {
    try {
      debugPrint("Is favorited:::🟢🟢🟢 $isFavorited");
      if (!isFavorited) {
        final response = await dio.post(
          ApiConstants.addUsersToFavorite(userId),
        );

        if (response.statusCode.toString().startsWith('2')) {
          return true;
        } else {
          throw ApiException(
            message: response.data['message'] ?? 'Fetch users failed',
            statusCode: response.statusCode ?? 500,
          );
        }
      } else {
        final response = await dio.delete(
          ApiConstants.addUsersToFavorite(userId),
        );

        if (response.statusCode.toString().startsWith('2')) {
          return true;
        } else {
          throw ApiException(
            message: response.data['message'] ?? 'Fetch users failed',
            statusCode: response.statusCode ?? 500,
          );
        }
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
  Future<UserProfileModel> getPublicProfiles({required String userId}) async {
    try {
      final response = await dio.get(ApiConstants.getPublicProfile(userId));

      if (response.statusCode.toString().startsWith('2')) {
        final userList = UserProfileModel.fromJson(response.data);

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
  @override
  Future<bool> addToHide({required String userId}) async {
    try {
      final response = await dio.post(ApiConstants.addToHide(userId));

      if (response.statusCode.toString().startsWith('2')) {
        return true;
      } else {
        throw ApiException(
          message: response.data['message'] ?? 'Failed to hide user',
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
  Future<bool> removeFromHide({required String userId}) async {
    try {
      final response = await dio.delete(ApiConstants.removeFromHide(userId));

      if (response.statusCode.toString().startsWith('2')) {
        return true;
      } else {
        throw ApiException(
          message:
              response.data['message'] ??
              'Failed to remove user from hidden list',
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
  Future<ResumeListModel> getHiddenUsers() async {
    try {
      final response = await dio.get(ApiConstants.getHiddenUsers);

      if (response.statusCode.toString().startsWith('2')) {
        final list = ResumeListModel.fromJson(response.data);
        return list;
      } else {
        throw ApiException(
          message: response.data['message'] ?? 'Failed to fetch hidden users',
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
