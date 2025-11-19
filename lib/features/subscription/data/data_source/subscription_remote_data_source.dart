import 'package:flutter/material.dart';
import 'package:mama_kris/constants/api_constants.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';
import 'package:mama_kris/features/emp/emp_resume/data/models/resume_list_model.dart';
import 'package:dio/dio.dart';
import 'package:mama_kris/features/subscription/data/model/subscription_model.dart';
import 'package:mama_kris/features/subscription/domain/entity/subscription_entity.dart';

abstract class SubscriptionRemoteDataSource {
  Future<List<SubscriptionModel>> getTariffs();
  Future<String?> initiatePayment(SubscriptionEntity tariff);
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  final Dio dio;

  SubscriptionRemoteDataSourceImpl(this.dio);

  @override
  Future<List<SubscriptionModel>> getTariffs() async {
    try {
      final userID = await sl<AuthLocalDataSource>().getUserId() ?? "";

      final response = await dio.get(ApiConstants.getTariffs);

      if (response.statusCode.toString().startsWith('2')) {
        final listData = response.data as List;

        final returnData = listData
            .map((data) => SubscriptionModel.fromJson(data))
            .toList();

        return returnData;
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
  Future<String?> initiatePayment(SubscriptionEntity tariff) async {
    try {
      final userID = await sl<AuthLocalDataSource>().getUserId() ?? "";
      if (userID.isEmpty) return null;

      final body = {
        "tariffType": tariff.type,
        "demoMode": false,
        // jobId is removed as per requirements
      };

      debugPrint("The same as month $body");

      final response = await dio.post(
        ApiConstants.generatePaymentLink(userID),
        data: body,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data.toString().trim();
      } else {
        throw ApiException(
          message: response.data['message'] ?? 'Payment link generation failed',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      debugPrint("Payment initiation error: $e");
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}
