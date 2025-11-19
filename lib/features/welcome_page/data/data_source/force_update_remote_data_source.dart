import 'package:dio/dio.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/features/welcome_page/data/model/force_update_model.dart';

abstract class ForceUpdateRemoteDataSource {
  Future<ForceUpdateModel> checkForceUpdate({
    required String versionNumber,
    required String platformType,
  });
}

class ForceUpdateRemoteDataSourceImpl implements ForceUpdateRemoteDataSource {
  final Dio dio;

  ForceUpdateRemoteDataSourceImpl(this.dio);

  @override
  Future<ForceUpdateModel> checkForceUpdate({
    required String versionNumber,
    required String platformType,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.forceUpdate,
        data: {"versionNumber": versionNumber, "platformType": platformType},
      );
      return ForceUpdateModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(message: _handleError(e), statusCode: 400);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      return e.response?.data['message']?.toString() ?? 'Something went wrong';
    } else {
      return e.message ?? 'Unexpected error';
    }
  }
}
