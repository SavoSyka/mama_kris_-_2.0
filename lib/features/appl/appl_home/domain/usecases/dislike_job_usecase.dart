import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/appl_home/domain/repositories/job_repository.dart';

class DislikeJobUseCase extends UsecaseWithParams<void, int> {
  final JobRepository repository;

  DislikeJobUseCase(this.repository);

  @override
  ResultFuture<void> call(int jobId) async {
    return await repository.dislikeJob(jobId);
  }
}
