import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/employe_home/domain/entity/employe_job_entity.dart';
import 'package:mama_kris/features/employe_home/domain/entity/job_post_entity.dart';
import 'package:mama_kris/features/employe_home/domain/repository/job_post_repository.dart';

class GetAllPostedJobUsecase
    extends UsecaseWithParams<List<EmployeJobEntity>, String> {
  final JobPostRepository repository;

  GetAllPostedJobUsecase(this.repository);

  @override
  ResultFuture<List<EmployeJobEntity>> call(String type) async {
    return await repository.getAllPostedJob(type: type);
  }
}
