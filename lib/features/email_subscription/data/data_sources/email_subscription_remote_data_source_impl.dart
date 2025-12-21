import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';
import 'package:mama_kris/features/email_subscription/data/data_sources/email_subscription_remote_data_source.dart';

class EmailSubscriptionRemoteDataSourceImpl
    implements EmailSubscriptionRemoteDataSource {
  final Dio dio;

  EmailSubscriptionRemoteDataSourceImpl(this.dio);

  @override
  ResultFuture<bool> subscribeEmail(String email) async {
    try {
      final userId = await sl<AuthLocalDataSource>().getUserId() ?? "";
      final response = await dio.post(
        ApiConstants.subscribeEmail(userId),
        data: {'email': email, 'userId': userId},
      );

      if (response.statusCode.toString().startsWith('2')) {
        return const Right(true);
      } else {
        throw ApiException(
          message: response.data['message'] ?? 'Email subscription failed',
          statusCode: response.statusCode ?? 400,
        );
      }
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  ResultFuture<bool> unsubscribeEmail(String email) async {
    try {
      final response = await dio.post(
        ApiConstants.unsubscribeEmail,
        data: {'email': email},
      );

      if (response.statusCode.toString().startsWith('2')) {
        return const Right(true);
      } else {
        throw ApiException(
          message: response.data['message'] ?? 'Email unsubscription failed',
          statusCode: response.statusCode ?? 400,
        );
      }
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}
