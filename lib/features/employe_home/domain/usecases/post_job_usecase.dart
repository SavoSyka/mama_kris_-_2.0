import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/employe_home/domain/entity/job_post_entity.dart';
import 'package:mama_kris/features/employe_home/domain/repository/job_post_repository.dart';

class PostJobUsecase extends UsecaseWithParams<void, JobPostEntity> {
  final JobPostRepository repository;

  PostJobUsecase(this.repository);

  @override
  ResultFuture<void> call(JobPostEntity params) async {
    return await repository.postJob(params);
  }
}