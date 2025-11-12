import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/emp/emp_home/domain/entities/create_job_params.dart';
import 'package:mama_kris/features/emp/emp_home/domain/repositories/emp_job_repository.dart';

class CreateJobUseCase extends UsecaseWithParams<void, CreateJobParams> {
  final EmpJobRepository repository;

  CreateJobUseCase(this.repository);

  @override
  ResultFuture<void> call(CreateJobParams params) async {
    return await repository.createJob(params);
  }
}