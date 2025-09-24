// domain/usecases/get_jobs.dart

import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/applicant_home/domain/entity/search_job_entity.dart';
import 'package:mama_kris/features/applicant_home/domain/repository/jobs_repository.dart';

class GetQueryJobsUsecase extends UsecaseWithParams<List<SearchJobEntity>, String> {
  final JobsRepository repository;

  GetQueryJobsUsecase(this.repository);

  @override
  ResultFuture<List<SearchJobEntity>> call(String query) async {
    return await repository.getQueryJobs(query: query);
  }
}
