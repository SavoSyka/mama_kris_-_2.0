import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/appl_favorite/domain/entity/liked_list_job.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_entity.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_list.dart';
import 'package:mama_kris/features/appl/appl_home/domain/repositories/job_repository.dart';

class FetchLikedJobs extends UsecaseWithParams<LikedListJob, int> {
  final JobRepository repository;

  FetchLikedJobs(this.repository);

  @override
  ResultFuture<LikedListJob> call(int page) async {
    return await repository.fetchLikedJobs(page);
  }
}
