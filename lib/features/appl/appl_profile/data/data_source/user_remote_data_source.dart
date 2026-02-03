import 'package:dio/dio.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';
import 'package:mama_kris/features/appl/app_auth/data/models/user_profile_model.dart';

abstract class UserRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl(this.dio);

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final userId = await sl<AuthLocalDataSource>().getUserId() ?? "";
      final response = await dio.get(ApiConstants.getUserProfile(userId));

      return UserProfileModel.fromJson(response.data);
    } on DioException catch (err) {
      throw ApiException(
        message: err.message,
        statusCode: err.response?.statusCode ?? 400,
      );
    } on ApiException {
      rethrow;
    } catch (err) {
      throw ApiException(message: err.toString(), statusCode: 400);
    }
  }
}
