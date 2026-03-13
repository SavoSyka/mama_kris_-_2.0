import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/features/stories/data/model/story_category_model.dart';

abstract class StoriesRemoteDataSource {
  Future<List<StoryCategoryModel>> getStoryCategories();
}

class StoriesRemoteDataSourceImpl implements StoriesRemoteDataSource {
  final Dio dio;

  StoriesRemoteDataSourceImpl(this.dio);

  @override
  Future<List<StoryCategoryModel>> getStoryCategories() async {
    try {
      final response = await dio.get(ApiConstants.getStories);

      if (response.statusCode.toString().startsWith('2')) {
        final listData = response.data as List;
        final categories = listData
            .map((data) => StoryCategoryModel.fromJson(data as Map<String, dynamic>))
            .where((c) => c.stories.isNotEmpty)
            .toList();
        categories.sort((a, b) => a.queue.compareTo(b.queue));
        return categories;
      } else {
        throw ApiException(
          message: response.data['message'] ?? 'Failed to fetch stories',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      debugPrint("error fetching stories: $e");
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}
