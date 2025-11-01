import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_entity.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_list.dart';
import 'package:mama_kris/features/appl/appl_home/domain/repositories/job_repository.dart';

class FetchJobsUseCase extends UsecaseWithoutParams<JobList> {
  final JobRepository repository;

  FetchJobsUseCase(this.repository);

  @override
  ResultFuture<JobList> call() async {
    return await repository.fetchJobs();
  }
}
