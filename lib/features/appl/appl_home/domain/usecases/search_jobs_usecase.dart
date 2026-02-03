import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_list.dart';
import 'package:mama_kris/features/appl/appl_home/domain/repositories/job_repository.dart';

class SearchJobsUseCase extends UsecaseWithParams<JobList, String> {
  final JobRepository repository;

  SearchJobsUseCase(this.repository);

  @override
  ResultFuture<JobList> call(String query) async {
    return await repository.searchJobs(query);
  }
}
