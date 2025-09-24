import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/features/applicant_home/data/data_source/jobs_local_data_source.dart';
import 'package:mama_kris/features/applicant_home/data/model/search_job_model.dart';
import 'package:mama_kris/features/auth/data/data_source/auth_local_data_source.dart';
import 'package:mama_kris/features/auth/data/model/user_model.dart';
import 'jobs_remote_data_source.dart';

class JobsRemoteDataSourceImpl implements JobsRemoteDataSource {
  final Dio dio;
  final JobsLocalDataSource local;

  JobsRemoteDataSourceImpl({required this.dio, required this.local});

  @override
  Future<List<SearchJobModel>> queryJobs({required String query}) async {
    try {
      final response = await dio.get(ApiConstants.searchJobs(query));

      debugPrint("Search query ${response.data}");

      final data = response.data as List<dynamic>;
      final List<SearchJobModel> jobList = data
          .map((e) => SearchJobModel.fromJson(e as String))
          .toList();

      debugPrint("Parsed jobs: $jobList");

      local.saveSearchQueries(query);

      return jobList;
    } on DioException catch (e) {
      throw ApiException(message: _handleError(e), statusCode: 400);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      return e.response?.data['message']?.toString() ?? 'Server error';
    } else {
      return e.message ?? 'Unexpected error';
    }
  }
}
