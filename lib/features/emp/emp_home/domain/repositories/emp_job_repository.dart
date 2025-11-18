import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/emp/emp_home/domain/entities/create_job_params.dart';
import 'package:mama_kris/features/emp/emp_home/domain/entities/emp_job_list_entity.dart';

abstract class EmpJobRepository {
  ResultFuture<void> createOrUpdateJob(CreateJobParams params);
  ResultFuture<EmpJobListEntity> fetchJobs({required String status, int page = 1});
}