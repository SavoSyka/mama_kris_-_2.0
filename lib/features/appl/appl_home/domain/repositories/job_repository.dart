import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/appl_favorite/domain/entity/liked_list_job.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_entity.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_list.dart';

abstract class JobRepository {
  ResultFuture<JobList> fetchJobs({required int page});

  ResultFuture<JobList> filterJobs({
    required int page,
    required int perPage,
    String? minSalary,
    String? maxSalary,
    String? title,
    bool? salaryWithAgreemen,
  });
  ResultFuture<JobList> searchJobs(String query);
  ResultFuture<void> likeJob(int jobId);
  ResultFuture<void> dislikeJob(int jobId);
  ResultFuture<LikedListJob> fetchLikedJobs(int page);
}
