import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/appl_home/domain/repositories/job_repository.dart';


class ViewJobUseCase extends UsecaseWithParams<void, int> {
  final JobRepository repository;

  ViewJobUseCase(this.repository);

  @override
  ResultFuture<void> call(int jobId) async {
    return await repository.viewJob(jobId);
  }
}
