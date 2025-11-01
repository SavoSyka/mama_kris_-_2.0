import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_entity.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_list.dart';

abstract class JobRepository {
  ResultFuture<JobList> fetchJobs();
  ResultFuture<JobList> searchJobs(String query);
  ResultFuture<void> likeJob(int jobId);
  ResultFuture<void> dislikeJob(int jobId);
}
