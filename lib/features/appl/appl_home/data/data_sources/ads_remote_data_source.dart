import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/features/appl/appl_home/data/models/ad_model.dart';

abstract class AdsRemoteDataSource {
  Future<AdModel> fetchAds();
}

class AdsRemoteDataSourceImpl implements AdsRemoteDataSource {
  final Dio dio;

  AdsRemoteDataSourceImpl(this.dio);

  @override
  Future<AdModel> fetchAds() async {
    try {
      final response = await dio.get(ApiConstants.getAds);

      if (response.statusCode.toString().startsWith('2')) {
        final data = response.data;
        final ads = AdModel.fromJson(data);
        debugPrint("addds found here ");
        return ads;
      } else {
        throw ApiException(
          message: response.data['message'] ?? 'Failed to fetch ads',
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
