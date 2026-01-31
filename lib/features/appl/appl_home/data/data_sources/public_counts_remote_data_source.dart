import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/features/appl/appl_home/data/models/public_counts_model.dart';

abstract class PublicCountsRemoteDataSource {
  Future<PublicCountsModel> getPublicCounts();
}

class PublicCountsRemoteDataSourceImpl implements PublicCountsRemoteDataSource {
  final Dio dio;

  PublicCountsRemoteDataSourceImpl(this.dio);

  @override
  Future<PublicCountsModel> getPublicCounts() async {
    try {
      final response = await dio.get(ApiConstants.getPublicCounts);

      if (response.statusCode.toString().startsWith('2')) {
        return PublicCountsModel.fromJson(response.data);
      } else {
        throw ApiException(
          message: response.data['message'] ?? 'Failed to fetch public counts',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      debugPrint("error fetching public counts: $e");
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}
