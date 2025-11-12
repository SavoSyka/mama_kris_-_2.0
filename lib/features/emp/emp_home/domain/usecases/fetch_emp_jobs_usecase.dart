import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/emp/emp_home/domain/entities/emp_job_list_entity.dart';
import 'package:mama_kris/features/emp/emp_home/domain/repositories/emp_job_repository.dart';

class FetchEmpJobsUseCase extends UsecaseWithParams<EmpJobListEntity, FetchEmpJobsParams> {
  final EmpJobRepository repository;

  FetchEmpJobsUseCase(this.repository);

  @override
  ResultFuture<EmpJobListEntity> call(FetchEmpJobsParams params) async {
    return await repository.fetchJobs(status: params.status, page: params.page);
  }
}

class FetchEmpJobsParams {
  final String status;
  final int page;

  const FetchEmpJobsParams({required this.status, this.page = 1});
}