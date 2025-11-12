import 'package:mama_kris/features/emp/emp_home/data/models/create_job_request_model.dart';
import 'package:mama_kris/features/emp/emp_home/data/models/emp_job_list_model.dart';

abstract class EmpJobRemoteDataSource {
  Future<void> createJob(CreateJobRequestModel request);
  Future<EmpJobListModel> fetchJobs({required String status, int page = 1});
}